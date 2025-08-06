import 'package:cloud_firestore/cloud_firestore.dart';
import 'subscription_model.dart';

enum UserRole {
  subscriber,
  admin,
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? dietaryPreferences;
  final DateTime createdAt;
  final UserSubscription subscription;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.dietaryPreferences,
    required this.createdAt,
    required this.subscription,
  });

  // Business logic methods
  bool get isAdmin => role == UserRole.admin;
  bool get canAccessSnacks => subscription.canAccessFullSnacks;
  bool get canMakeRequests => subscription.status == SubscriptionStatus.active;
  bool get canVote => subscription.status == SubscriptionStatus.active;

  factory AppUser.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUser(
      id: documentId,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.subscriber,
      ),
      dietaryPreferences: map['dietaryPreferences'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      subscription: UserSubscription.fromMap(map['subscription'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'dietaryPreferences': dietaryPreferences,
      'createdAt': Timestamp.fromDate(createdAt),
      'subscription': subscription.toMap(),
    };
  }

  AppUser copyWith({
    String? name,
    UserRole? role,
    String? dietaryPreferences,
    UserSubscription? subscription,
  }) {
    return AppUser(
      id: id,
      email: email,
      name: name ?? this.name,
      role: role ?? this.role,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      createdAt: createdAt,
      subscription: subscription ?? this.subscription,
    );
  }
}
