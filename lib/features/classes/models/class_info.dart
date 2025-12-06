// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class ClassInfo {
  final String classId; // unique ID for the class/group
  final String sectionId;
  final String teacherId;
  final String courseId;
  final String branchId;
  final String batchId;
  final String? defaultRoomNo;
  final List<String> studentIds;

  ClassInfo({
    required this.classId,
    required this.sectionId,
    required this.teacherId,
    required this.courseId,
    required this.branchId,
    required this.batchId,
    this.defaultRoomNo,
    required this.studentIds,
  });

  ClassInfo copyWith({
    String? classId,
    String? sectionId,
    String? teacherId,
    String? courseId,
    String? branchId,
    String? batchId,
    String? defaultRoomNo,
    List<String>? studentIds,
  }) {
    return ClassInfo(
      classId: classId ?? this.classId,
      sectionId: sectionId ?? this.sectionId,
      teacherId: teacherId ?? this.teacherId,
      courseId: courseId ?? this.courseId,
      branchId: branchId ?? this.branchId,
      batchId: batchId ?? this.batchId,
      defaultRoomNo: defaultRoomNo ?? this.defaultRoomNo,
      studentIds: studentIds ?? this.studentIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classId': classId,
      'sectionId': sectionId,
      'teacherId': teacherId,
      'courseId': courseId,
      'branchId': branchId,
      'batchId': batchId,
      'defaultRoomNo': defaultRoomNo,
      'studentIds': studentIds,
    };
  }

  factory ClassInfo.fromMap(Map<String, dynamic> map) {
    return ClassInfo(
        classId: map['classId'] as String,
        sectionId: map['sectionId'] as String,
        teacherId: map['teacherId'] as String,
        courseId: map['courseId'] as String,
        branchId: map['branchId'] as String,
        batchId: map['batchId'] as String,
        defaultRoomNo: map['defaultRoomNo'] != null ? map['defaultRoomNo'] as String : null,
        studentIds: List<String>.from((map['studentIds'] as List<String>),
    ));
  }

  String toJson() => json.encode(toMap());

  factory ClassInfo.fromJson(String source) => ClassInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassInfo(classId: $classId, sectionId: $sectionId, teacherId: $teacherId, courseId: $courseId, branchId: $branchId, batchId: $batchId, defaultRoomNo: $defaultRoomNo, studentIds: $studentIds)';
  }

  @override
  bool operator ==(covariant ClassInfo other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return
      other.classId == classId &&
          other.sectionId == sectionId &&
          other.teacherId == teacherId &&
          other.courseId == courseId &&
          other.branchId == branchId &&
          other.batchId == batchId &&
          other.defaultRoomNo == defaultRoomNo &&
          listEquals(other.studentIds, studentIds);
  }

  @override
  int get hashCode {
    return classId.hashCode ^
    sectionId.hashCode ^
    teacherId.hashCode ^
    courseId.hashCode ^
    branchId.hashCode ^
    batchId.hashCode ^
    defaultRoomNo.hashCode ^
    studentIds.hashCode;
  }
}
