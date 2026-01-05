import '../../settings/models/class_schedule.dart';

class CollegeDetail {
  final String? collegeBanner;
  final String collegeName;
  final bool isSuperAdminExist;
  final String? logo;
  final String id;
  final CollegeSchedule? collegeSchedule;

  const CollegeDetail({
    this.collegeBanner,
    required this.collegeName,
    required this.isSuperAdminExist,
    this.logo,
    required this.id,
    this.collegeSchedule,
  });

  factory CollegeDetail.fromMap(Map<String, dynamic> map) {
    return CollegeDetail(
      collegeBanner: map['collegeBanner'],
      collegeName: map['collegeName'],
      isSuperAdminExist: map['isSuperAdminExist'],
      logo: map['logo'],
      id: map['id'],
      collegeSchedule: map['collegeSchedule'] != null
          ? CollegeSchedule.fromMap(
        Map<String, dynamic>.from(map['collegeSchedule']),
      )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collegeBanner': collegeBanner,
      'collegeName': collegeName,
      'isSuperAdminExist': isSuperAdminExist,
      'logo': logo,
      'id': id,
      'collegeSchedule': collegeSchedule?.toMap(),
    };
  }
}
