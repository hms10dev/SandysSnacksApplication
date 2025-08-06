// lib/utils/enums.dart
enum UserRole {
  subscriber,
  admin,
}

enum SubscriptionStatus {
  inactive,
  active,
  overdue,
  paused,
}

enum RequestStatus {
  pending,
  reviewing,
  fulfilled,
  rejected,
}

enum PaymentMethod {
  venmo,
  zelle,
}
