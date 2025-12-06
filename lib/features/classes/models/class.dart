// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'class_review.dart';

class ClassSession {
  final String classId;
  final String sectionId;
  final String subjectId;
  final String teacherId;
  final String branchId;
  final String batchId;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isLive;
  final String? roomNo;
  final String? attendanceId;
  final bool isAttendanceMarked;
  final List<ClassReview> reviews;
  ClassSession({
    required this.classId,
    required this.sectionId,
    required this.subjectId,
    required this.teacherId,
    required this.branchId,
    required this.batchId,
    required this.startTime,
    this.endTime,
    required this.isLive,
    this.roomNo,
    this.attendanceId,
    required this.isAttendanceMarked,
    required this.reviews,
  });

  ClassSession copyWith({
    String? classId,
    String? sectionId,
    String? subjectId,
    String? teacherId,
    String? branchId,
    String? batchId,
    DateTime? startTime,
    DateTime? endTime,
    bool? isLive,
    String? roomNo,
    String? attendanceId,
    bool? isAttendanceMarked,
    List<ClassReview>? reviews,
  }) {
    return ClassSession(
      classId: classId ?? this.classId,
      sectionId: sectionId ?? this.sectionId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      branchId: branchId ?? this.branchId,
      batchId: batchId ?? this.batchId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isLive: isLive ?? this.isLive,
      roomNo: roomNo ?? this.roomNo,
      attendanceId: attendanceId ?? this.attendanceId,
      isAttendanceMarked: isAttendanceMarked ?? this.isAttendanceMarked,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classId': classId,
      'sectionId': sectionId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'branchId': branchId,
      'batchId': batchId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'isLive': isLive,
      'roomNo': roomNo,
      'attendanceId': attendanceId,
      'isAttendanceMarked': isAttendanceMarked,
      'reviews': reviews.map((x) => x.toMap()).toList(),
    };
  }

  factory ClassSession.fromMap(Map<String, dynamic> map) {
    return ClassSession(
      classId: map['classId'] as String,
      sectionId: map['sectionId'] as String,
      subjectId: map['subjectId'] as String,
      teacherId: map['teacherId'] as String,
      branchId: map['branchId'] as String,
      batchId: map['batchId'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: map['endTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int) : null,
      isLive: map['isLive'] as bool,
      roomNo: map['roomNo'] != null ? map['roomNo'] as String : null,
      attendanceId: map['attendanceId'] != null ? map['attendanceId'] as String : null,
      isAttendanceMarked: map['isAttendanceMarked'] as bool,
      reviews: List<ClassReview>.from((map['reviews'] as List<int>).map<ClassReview>((x) => ClassReview.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassSession.fromJson(String source) => ClassSession.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassSession(classId: $classId, sectionId: $sectionId, subjectId: $subjectId, teacherId: $teacherId, branchId: $branchId, batchId: $batchId, startTime: $startTime, endTime: $endTime, isLive: $isLive, roomNo: $roomNo, attendanceId: $attendanceId, isAttendanceMarked: $isAttendanceMarked, reviews: $reviews)';
  }

  @override
  bool operator ==(covariant ClassSession other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return
      other.classId == classId &&
          other.sectionId == sectionId &&
          other.subjectId == subjectId &&
          other.teacherId == teacherId &&
          other.branchId == branchId &&
          other.batchId == batchId &&
          other.startTime == startTime &&
          other.endTime == endTime &&
          other.isLive == isLive &&
          other.roomNo == roomNo &&
          other.attendanceId == attendanceId &&
          other.isAttendanceMarked == isAttendanceMarked &&
          listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode {
    return classId.hashCode ^
    sectionId.hashCode ^
    subjectId.hashCode ^
    teacherId.hashCode ^
    branchId.hashCode ^
    batchId.hashCode ^
    startTime.hashCode ^
    endTime.hashCode ^
    isLive.hashCode ^
    roomNo.hashCode ^
    attendanceId.hashCode ^
    isAttendanceMarked.hashCode ^
    reviews.hashCode;
  }
}
