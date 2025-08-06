import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandys_snacks_app/models/subscription_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State
  User? _user;
  String? _userName;
  UserSubscription? _subscription;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  String? get userName => _userName;
  UserSubscription? get subscription => _subscription;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // Auth state handling
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _clearUserData();
    }
    notifyListeners();
  }

  void _clearUserData() {
    _userName = null;
    _subscription = null;
    _error = null;
  }

  // Load user data
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _userName = data['name'] ?? 'User';

        // Load subscription data
        final subData = data['subscription'] as Map<String, dynamic>?;
        if (subData != null) {
          _subscription = UserSubscription.fromMap(subData);
        } else {
          _subscription = _createDefaultSubscription();
          await _saveSubscriptionData();
        }

        await _updateSubscriptionStatusIfNeeded();
      }
    } catch (e) {
      _error = 'Error loading user data: $e';
      debugPrint(_error);
    }
    notifyListeners();
  }

  UserSubscription _createDefaultSubscription() {
    return UserSubscription(
      status: SubscriptionStatus.inactive,
      tasteSamplesUsed: 0,
      lastTasteSampleReset: DateTime.now(),
    );
  }

  // YOUR business logic for status updates
  Future<void> _updateSubscriptionStatusIfNeeded() async {
    if (_subscription == null) return;

    final now = DateTime.now();
    bool needsUpdate = false;
    UserSubscription updatedSub = _subscription!;

    // Check if active subscription is now overdue
    if (_subscription!.status == SubscriptionStatus.active &&
        _subscription!.nextDueDate != null &&
        _subscription!.nextDueDate!.isBefore(now)) {
      updatedSub = _subscription!.copyWith(status: SubscriptionStatus.overdue);
      needsUpdate = true;
    }

    // Reset taste samples monthly
    if (_shouldResetTasteSamples(now)) {
      updatedSub = updatedSub.copyWith(
        tasteSamplesUsed: 0,
        lastTasteSampleReset: now,
      );
      needsUpdate = true;
    }

    if (needsUpdate) {
      _subscription = updatedSub;
      await _saveSubscriptionData();
    }
  }

  bool _shouldResetTasteSamples(DateTime now) {
    return _subscription!.lastTasteSampleReset == null ||
        now.month != _subscription!.lastTasteSampleReset!.month ||
        now.year != _subscription!.lastTasteSampleReset!.year;
  }

  // Authentication methods
  Future<bool> signUp(String email, String password, String name) async {
    return _performAuthAction(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
        'subscription': _createDefaultSubscription().toMap(),
      });
    });
  }

  Future<bool> signIn(String email, String password) async {
    return _performAuthAction(() async {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // YOUR subscription business methods
  Future<bool> processPayment() async {
    if (_user == null || _subscription == null) return false;

    try {
      final now = DateTime.now();
      final nextDue = DateTime(now.year, now.month + 1, now.day);

      _subscription = _subscription!.copyWith(
        status: SubscriptionStatus.active,
        nextDueDate: nextDue,
        lastPaymentDate: now,
      );

      await _saveSubscriptionData();
      return true;
    } catch (e) {
      _error = 'Payment processing error: $e';
      debugPrint(_error);
      notifyListeners();
      return false;
    }
  }

  Future<void> pauseSubscription() async {
    if (_user == null || _subscription == null) return;

    _subscription = _subscription!.copyWith(
      status: SubscriptionStatus.paused,
      nextDueDate: null,
    );

    await _saveSubscriptionData();
  }

  Future<void> reactivateSubscription() async {
    if (_user == null || _subscription == null) return;

    // Reactivation requires payment
    _subscription = _subscription!.copyWith(
      status: SubscriptionStatus.inactive,
    );

    await _saveSubscriptionData();
  }

  Future<void> recordTasteSample() async {
    if (_user == null || _subscription == null) return;
    if (!_subscription!.canAccessTasteSamples) return;

    _subscription = _subscription!.copyWith(
      tasteSamplesUsed: _subscription!.tasteSamplesUsed + 1,
    );

    await _saveSubscriptionData();
  }

  // Helper methods
  Future<void> _saveSubscriptionData() async {
    if (_user == null || _subscription == null) return;

    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'subscription': _subscription!.toMap(),
      });
      notifyListeners();
    } catch (e) {
      _error = 'Error saving subscription data: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  Future<bool> _performAuthAction(Future<void> Function() action) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await action();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
