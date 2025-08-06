import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sandys_snacks_app/models/subscription_model.dart';
import '../models/request_model.dart';
import 'package:sandys_snacks_app/models/models.dart';

class AdminService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AppUser> _allUsers = [];
  List<SnackRequest> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  List<AppUser> get allUsers => _allUsers;
  List<SnackRequest> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all users for admin overview
  Future<void> loadAllUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      _allUsers = querySnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      _error = 'Error loading users: $e';
      _allUsers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get subscription overview stats
  Map<String, dynamic> getSubscriptionStats() {
    final activeSubscribers = _allUsers
        .where((user) => user.subscription.status == SubscriptionStatus.active)
        .length;

    final overdueSubscribers = _allUsers
        .where((user) => user.subscription.status == SubscriptionStatus.overdue)
        .length;

    final totalRevenue = activeSubscribers * 5.0; // $5 per active subscriber

    return {
      'activeSubscribers': activeSubscribers,
      'overdueSubscribers': overdueSubscribers,
      'totalUsers': _allUsers.length,
      'monthlyRevenue': totalRevenue,
    };
  }

  // Load pending requests for review
  Future<void> loadPendingRequests() async {
    try {
      final now = DateTime.now();
      final currentMonth = _getMonthName(now.month);

      final querySnapshot = await _firestore
          .collection('requests')
          .where('month', isEqualTo: currentMonth)
          .where('year', isEqualTo: now.year)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      _pendingRequests = querySnapshot.docs
          .map((doc) => SnackRequest.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      _error = 'Error loading requests: $e';
      notifyListeners();
    }
  }

  // Sandy's function: Update user subscription status
  Future<bool> updateUserSubscriptionStatus(
      String userId, SubscriptionStatus newStatus) async {
    try {
      final userIndex = _allUsers.indexWhere((user) => user.id == userId);
      if (userIndex == -1) return false;

      final user = _allUsers[userIndex];
      final updatedSubscription = user.subscription.copyWith(status: newStatus);

      // Update in Firestore
      await _firestore.collection('users').doc(userId).update({
        'subscription': updatedSubscription.toMap(),
      });

      // Update local state
      _allUsers[userIndex] = user.copyWith(subscription: updatedSubscription);
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Error updating subscription: $e';
      notifyListeners();
      return false;
    }
  }

  // Sandy's function: Send notification to all active subscribers
  Future<bool> sendNotificationToSubscribers(String message) async {
    try {
      // In a real app, this would use Firebase Cloud Messaging
      // For now, we'll just log it
      debugPrint('Sending notification: $message');

      // Could also store notifications in Firestore for in-app display
      await _firestore.collection('notifications').add({
        'message': message,
        'createdAt': Timestamp.now(),
        'targetAudience': 'active_subscribers',
      });

      return true;
    } catch (e) {
      _error = 'Error sending notification: $e';
      notifyListeners();
      return false;
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
