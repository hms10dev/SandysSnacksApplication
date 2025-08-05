import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _userName;
  bool _isLoading = false;

  // Getters
  User? get user => _user;
  String? get userName => _userName;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  AuthService() {
    // Listen to auth changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserName();
      } else {
        _userName = null;
      }
      notifyListeners();
    });
  }

  // Load user's name from Firestore
  Future<void> _loadUserName() async {
    if (_user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _userName = doc.data()?['name'] ?? 'User';
      }
    } catch (e) {
      print('Error loading user name: $e');
      _userName = 'User';
    }
    notifyListeners();
  }

  // Sign up
  Future<bool> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      print('Signin error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
