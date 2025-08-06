import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/snack_model.dart';

class SnackService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Snack> _currentSnacks = [];
  bool _isLoading = false;
  String? _error;

  List<Snack> get currentSnacks => _currentSnacks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get current month's snacks
  Future<void> getCurrentMonthSnacks({bool subscriberOnly = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final currentMonth = _getMonthName(now.month);
      final currentYear = now.year;

      Query query = _firestore
          .collection('snacks')
          .where('month', isEqualTo: currentMonth)
          .where('year', isEqualTo: currentYear);

      // Filter for subscriber-only content
      if (subscriberOnly) {
        query = query.where('isSubscriberOnly', isEqualTo: true);
      }

      final querySnapshot =
          await query.orderBy('createdAt', descending: false).get();

      _currentSnacks = querySnapshot.docs
          .map((doc) =>
              Snack.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      _error = 'Error loading snacks: $e';
      _currentSnacks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sandy's admin function: Add new snack
  Future<bool> addSnack({
    required String name,
    required String description,
    required List<String> categories,
    required List<String> dietaryTags,
    required String curatorId,
    String? imageFile, // Base64 or file path
    bool isSubscriberOnly = false,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final now = DateTime.now();
      String photoUrl = '';

      // Upload image if provided
      if (imageFile != null) {
        photoUrl = await _uploadSnackImage(imageFile, name);
      }

      final snack = Snack(
        id: '', // Will be set by Firestore
        month: _getMonthName(now.month),
        year: now.year,
        curatorId: curatorId,
        name: name,
        description: description,
        photoUrl: photoUrl,
        categories: categories,
        dietaryTags: dietaryTags,
        createdAt: now,
        isSubscriberOnly: isSubscriberOnly,
      );

      await _firestore.collection('snacks').add(snack.toMap());

      // Refresh current snacks
      await getCurrentMonthSnacks();
      return true;
    } catch (e) {
      _error = 'Error adding snack: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Upload snack image to Firebase Storage
  Future<String> _uploadSnackImage(String imageFile, String snackName) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$snackName.jpg';
      final ref = _storage.ref().child('snack_images/$fileName');

      // In a real app, you'd upload the actual file here
      // For now, we'll return a placeholder URL
      return 'https://via.placeholder.com/300x200?text=$snackName';
    } catch (e) {
      throw Exception('Failed to upload image: $e');
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
