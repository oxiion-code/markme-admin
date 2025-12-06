import 'dart:convert';

class Semester {
  final String semesterId;
  final int semesterNumber;
  final String courseId;
  final int startDate;
  final int endDate;

  const Semester({
    required this.semesterId,
    required this.semesterNumber,
    required this.courseId,
    required this.startDate,
    required this.endDate,
  });

  Semester copyWith({
    String? semesterId,
    int? semesterNumber,
    String? courseId,
    int? startDate,
    int? endDate,
  }) {
    return Semester(
      semesterId: semesterId ?? this.semesterId,
      semesterNumber: semesterNumber ?? this.semesterNumber,
      courseId: courseId ?? this.courseId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semesterId': semesterId,
      'semesterNumber': semesterNumber,
      'courseId': courseId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      semesterId: map['semesterId'] as String,
      semesterNumber: map['semesterNumber'] is String
          ? int.parse(map['semesterNumber'])
          : map['semesterNumber'] as int,
      courseId: map['courseId'] as String,
      startDate: map['startDate'] as int,
      endDate: map['endDate'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Semester.fromJson(String source) =>
      Semester.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Semester(semesterId: $semesterId, semesterNumber: $semesterNumber, courseId: $courseId, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant Semester other) {
    if (identical(this, other)) return true;

    return other.semesterId == semesterId &&
        other.semesterNumber == semesterNumber &&
        other.courseId == courseId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return semesterId.hashCode ^
    semesterNumber.hashCode ^
    courseId.hashCode ^
    startDate.hashCode ^
    endDate.hashCode;
  }
}
