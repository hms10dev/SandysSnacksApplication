import 'package:cloud_firestore/cloud_firestore.dart';

enum SubscriptionStatus {
  inactive,
  active,
  overdue,
  paused,
}

class UserSubscription {
  final SubscriptionStatus status;
  final DateTime? nextDueDate;
  final DateTime? lastPaymentDate;
  final int tasteSamplesUsed;
  final DateTime? lastTasteSampleReset;

  UserSubscription({
    required this.status,
    this.nextDueDate,
    this.lastPaymentDate,
    this.tasteSamplesUsed = 0,
    this.lastTasteSampleReset,
  });

  // YOUR business logic methods
  bool get canAccessFullSnacks => status == SubscriptionStatus.active;

  bool get canAccessTasteSamples {
    final now = DateTime.now();
    final shouldReset = _shouldResetTasteSamples(now);

    if (shouldReset) return true;
    return tasteSamplesUsed < 2;
  }

  bool get isOverdue {
    if (nextDueDate == null) return false;
    return nextDueDate!.isBefore(DateTime.now()) &&
        status == SubscriptionStatus.overdue;
  }

  bool get shouldPromptForPauseOrPay {
    if (nextDueDate == null) return false;
    final daysPastDue = DateTime.now().difference(nextDueDate!).inDays;
    return daysPastDue >= 3 && status == SubscriptionStatus.overdue;
  }

  String get statusMessage {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Active until ${_formatDate(nextDueDate)}';
      case SubscriptionStatus.overdue:
        final daysPastDue = DateTime.now().difference(nextDueDate!).inDays;
        return 'Payment overdue by $daysPastDue days';
      case SubscriptionStatus.paused:
        return 'Subscription paused';
      case SubscriptionStatus.inactive:
        return 'Subscribe to access full snacks';
    }
  }

  // Helper methods
  bool _shouldResetTasteSamples(DateTime now) {
    return lastTasteSampleReset == null ||
        now.month != lastTasteSampleReset!.month ||
        now.year != lastTasteSampleReset!.year;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.month}/${date.day}/${date.year}';
  }

  // Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'status': status.toString().split('.').last,
      'nextDueDate':
          nextDueDate != null ? Timestamp.fromDate(nextDueDate!) : null,
      'lastPaymentDate':
          lastPaymentDate != null ? Timestamp.fromDate(lastPaymentDate!) : null,
      'tasteSamplesUsed': tasteSamplesUsed,
      'lastTasteSampleReset': lastTasteSampleReset != null
          ? Timestamp.fromDate(lastTasteSampleReset!)
          : null,
    };
  }

  factory UserSubscription.fromMap(Map<String, dynamic> map) {
    return UserSubscription(
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => SubscriptionStatus.inactive,
      ),
      nextDueDate: map['nextDueDate'] != null
          ? (map['nextDueDate'] as Timestamp).toDate()
          : null,
      lastPaymentDate: map['lastPaymentDate'] != null
          ? (map['lastPaymentDate'] as Timestamp).toDate()
          : null,
      tasteSamplesUsed: map['tasteSamplesUsed'] ?? 0,
      lastTasteSampleReset: map['lastTasteSampleReset'] != null
          ? (map['lastTasteSampleReset'] as Timestamp).toDate()
          : null,
    );
  }

  // Create new subscription with updated status
  UserSubscription copyWith({
    SubscriptionStatus? status,
    DateTime? nextDueDate,
    DateTime? lastPaymentDate,
    int? tasteSamplesUsed,
    DateTime? lastTasteSampleReset,
  }) {
    return UserSubscription(
      status: status ?? this.status,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      tasteSamplesUsed: tasteSamplesUsed ?? this.tasteSamplesUsed,
      lastTasteSampleReset: lastTasteSampleReset ?? this.lastTasteSampleReset,
    );
  }
}
