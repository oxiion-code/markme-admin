import 'package:cloud_firestore/cloud_firestore.dart';

class SessionAttendanceModel {
  final String attendanceId;
  final String sessionId;
  final Map<String, bool> applicants;

  final DateTime? createdAt;

  SessionAttendanceModel({
    required this.attendanceId,
    required this.sessionId,
    required this.applicants,
    this.createdAt,
  });

  // 🔥 Firestore → Model
  factory SessionAttendanceModel.fromJson(Map<String, dynamic> json) {
    return SessionAttendanceModel(
      attendanceId: json['attendanceId'] as String,
      sessionId: json['sessionId'] as String,
      applicants: Map<String, bool>.from(json['applicants'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // 🔥 Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'sessionId': sessionId,
      'applicants': applicants,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }



  int get totalApplicants => applicants.length;

  int get presentCount =>
      applicants.values.where((v) => v == true).length;

  int get absentCount =>
      applicants.values.where((v) => v == false).length;

  bool isStudentPresent(String studentId) =>
      applicants[studentId] ?? false;
}
