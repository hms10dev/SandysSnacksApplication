import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus {
  pending,
  reviewing,
  fulfilled,
  rejected,
}

class SnackRequest {
  final String id;
  final String userId;
  final String userName; // For easy display
  final String month;
  final int year;
  final String requestText;
  final RequestStatus status;
  final DateTime createdAt;
  final String? adminNotes;

  SnackRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.month,
    required this.year,
    required this.requestText,
    required this.status,
    required this.createdAt,
    this.adminNotes,
  });

  factory SnackRequest.fromMap(Map<String, dynamic> map, String documentId) {
    return SnackRequest(
      id: documentId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      month: map['month'] ?? '',
      year: map['year'] ?? 0,
      requestText: map['requestText'] ?? '',
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => RequestStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      adminNotes: map['adminNotes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'month': month,
      'year': year,
      'requestText': requestText,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'adminNotes': adminNotes,
    };
  }
}
