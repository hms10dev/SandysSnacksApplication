import 'package:cloud_firestore/cloud_firestore.dart';

class Snack {
  final String id;
  final String month;
  final int year;
  final String curatorId; // Sandy's user ID
  final String name;
  final String description;
  final String photoUrl;
  final List<String> categories;
  final List<String> dietaryTags;
  final double? averageRating;
  final DateTime createdAt;
  final bool isSubscriberOnly;

  Snack({
    required this.id,
    required this.month,
    required this.year,
    required this.curatorId,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.categories,
    required this.dietaryTags,
    this.averageRating,
    required this.createdAt,
    this.isSubscriberOnly = false,
  });

  factory Snack.fromMap(Map<String, dynamic> map, String documentId) {
    return Snack(
      id: documentId,
      month: map['month'] ?? '',
      year: map['year'] ?? 0,
      curatorId: map['curatorId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      dietaryTags: List<String>.from(map['dietaryTags'] ?? []),
      averageRating: map['averageRating']?.toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isSubscriberOnly: map['isSubscriberOnly'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'year': year,
      'curatorId': curatorId,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'categories': categories,
      'dietaryTags': dietaryTags,
      'averageRating': averageRating,
      'createdAt': Timestamp.fromDate(createdAt),
      'isSubscriberOnly': isSubscriberOnly,
    };
  }
}
