// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlacementForm {
  final String applicationId;
  final String sessionId;
  final String companyId;
  final String companyName;
  final String jobTitle;

  // Student Basic Info
  final String studentName;
  final String registrationNo;
  final String course;
  final String branch;

  // 10th Details
  final String tenthCollegeName;
  final String tenthCertificateUrl;
  final String tenthCgpaOrPercentage;

  // 12th Details
  final String twelfthCollegeName;
  final String twelfthCertificateUrl;
  final String twelfthCgpaOrPercentage;

  // Graduation Details
  final String graduationCollegeName;
  final String graduationCertificateUrl;
  final String graduationCgpaOrPercentage;

  // Masters / Post Graduation Details
  final String mastersCollegeName;
  final String mastersCertificateUrl;
  final String mastersCgpaOrPercentage;

  // Undertaking
  final String undertakingDescription;
  final String undertakingDate;

  // Signature
  final String signatureUrl;

  // Selection
  final bool isSelected;

  final String createdAt;

  const PlacementForm({
    required this.applicationId,
    required this.sessionId,
    required this.companyId,
    required this.companyName,
    required this.jobTitle,
    required this.studentName,
    required this.registrationNo,
    required this.course,
    required this.branch,
    required this.tenthCollegeName,
    required this.tenthCertificateUrl,
    required this.tenthCgpaOrPercentage,
    required this.twelfthCollegeName,
    required this.twelfthCertificateUrl,
    required this.twelfthCgpaOrPercentage,
    required this.graduationCollegeName,
    required this.graduationCertificateUrl,
    required this.graduationCgpaOrPercentage,
    required this.mastersCollegeName,
    required this.mastersCertificateUrl,
    required this.mastersCgpaOrPercentage,
    required this.undertakingDescription,
    required this.undertakingDate,
    required this.signatureUrl,
    required this.isSelected,
    required this.createdAt,
  });

  PlacementForm copyWith({
    String? applicationId,
    String? sessionId,
    String? companyId,
    String? companyName,
    String? jobTitle,
    String? studentName,
    String? registrationNo,
    String? course,
    String? branch,
    String? tenthCollegeName,
    String? tenthCertificateUrl,
    String? tenthCgpaOrPercentage,
    String? twelfthCollegeName,
    String? twelfthCertificateUrl,
    String? twelfthCgpaOrPercentage,
    String? graduationCollegeName,
    String? graduationCertificateUrl,
    String? graduationCgpaOrPercentage,
    String? mastersCollegeName,
    String? mastersCertificateUrl,
    String? mastersCgpaOrPercentage,
    String? undertakingDescription,
    String? undertakingDate,
    String? signatureUrl,
    bool? isSelected,
    String? createdAt,
  }) {
    return PlacementForm(
      applicationId: applicationId ?? this.applicationId,
      sessionId: sessionId ?? this.sessionId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      studentName: studentName ?? this.studentName,
      registrationNo: registrationNo ?? this.registrationNo,
      course: course ?? this.course,
      branch: branch ?? this.branch,
      tenthCollegeName: tenthCollegeName ?? this.tenthCollegeName,
      tenthCertificateUrl: tenthCertificateUrl ?? this.tenthCertificateUrl,
      tenthCgpaOrPercentage:
      tenthCgpaOrPercentage ?? this.tenthCgpaOrPercentage,
      twelfthCollegeName: twelfthCollegeName ?? this.twelfthCollegeName,
      twelfthCertificateUrl: twelfthCertificateUrl ?? this.twelfthCertificateUrl,
      twelfthCgpaOrPercentage:
      twelfthCgpaOrPercentage ?? this.twelfthCgpaOrPercentage,
      graduationCollegeName:
      graduationCollegeName ?? this.graduationCollegeName,
      graduationCertificateUrl:
      graduationCertificateUrl ?? this.graduationCertificateUrl,
      graduationCgpaOrPercentage:
      graduationCgpaOrPercentage ?? this.graduationCgpaOrPercentage,
      mastersCollegeName: mastersCollegeName ?? this.mastersCollegeName,
      mastersCertificateUrl:
      mastersCertificateUrl ?? this.mastersCertificateUrl,
      mastersCgpaOrPercentage:
      mastersCgpaOrPercentage ?? this.mastersCgpaOrPercentage,
      undertakingDescription:
      undertakingDescription ?? this.undertakingDescription,
      undertakingDate: undertakingDate ?? this.undertakingDate,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'applicationId': applicationId,
      'sessionId': sessionId,
      'companyId': companyId,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'studentName': studentName,
      'registrationNo': registrationNo,
      'course': course,
      'branch': branch,
      'tenthCollegeName': tenthCollegeName,
      'tenthCertificateUrl': tenthCertificateUrl,
      'tenthCgpaOrPercentage': tenthCgpaOrPercentage,
      'twelfthCollegeName': twelfthCollegeName,
      'twelfthCertificateUrl': twelfthCertificateUrl,
      'twelfthCgpaOrPercentage': twelfthCgpaOrPercentage,
      'graduationCollegeName': graduationCollegeName,
      'graduationCertificateUrl': graduationCertificateUrl,
      'graduationCgpaOrPercentage': graduationCgpaOrPercentage,
      'mastersCollegeName': mastersCollegeName,
      'mastersCertificateUrl': mastersCertificateUrl,
      'mastersCgpaOrPercentage': mastersCgpaOrPercentage,
      'undertakingDescription': undertakingDescription,
      'undertakingDate': undertakingDate,
      'signatureUrl': signatureUrl,
      'isSelected': isSelected,
      'createdAt': createdAt,
    };
  }

  factory PlacementForm.fromMap(Map<String, dynamic> map) {
    return PlacementForm(
      applicationId: map['applicationId'] as String,
      sessionId: map['sessionId'] as String,
      companyId: map['companyId'] as String,
      companyName: map['companyName'] as String,
      jobTitle: map['jobTitle'] as String,
      studentName: map['studentName'] as String,
      registrationNo: map['registrationNo'] as String,
      course: map['course'] as String,
      branch: map['branch'] as String,
      tenthCollegeName: map['tenthCollegeName'] as String,
      tenthCertificateUrl: map['tenthCertificateUrl'] as String,
      tenthCgpaOrPercentage: map['tenthCgpaOrPercentage'] as String,
      twelfthCollegeName: map['twelfthCollegeName'] as String,
      twelfthCertificateUrl: map['twelfthCertificateUrl'] as String,
      twelfthCgpaOrPercentage: map['twelfthCgpaOrPercentage'] as String,
      graduationCollegeName: map['graduationCollegeName'] as String,
      graduationCertificateUrl: map['graduationCertificateUrl'] as String,
      graduationCgpaOrPercentage:
      map['graduationCgpaOrPercentage'] as String,
      mastersCollegeName: map['mastersCollegeName'] as String,
      mastersCertificateUrl: map['mastersCertificateUrl'] as String,
      mastersCgpaOrPercentage: map['mastersCgpaOrPercentage'] as String,
      undertakingDescription: map['undertakingDescription'] as String,
      undertakingDate: map['undertakingDate'] as String,
      signatureUrl: map['signatureUrl'] as String,
      isSelected: map['isSelected'] as bool,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlacementForm.fromJson(String source) =>
      PlacementForm.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlacementApplication(applicationId: $applicationId, sessionId: $sessionId, companyId: $companyId, companyName: $companyName, jobTitle: $jobTitle, studentName: $studentName, registrationNo: $registrationNo, course: $course, branch: $branch, isSelected: $isSelected)';
  }

  @override
  bool operator ==(covariant PlacementForm other) {
    if (identical(this, other)) return true;
    return other.applicationId == applicationId &&
        other.sessionId == sessionId &&
        other.companyId == companyId &&
        other.companyName == companyName &&
        other.jobTitle == jobTitle &&
        other.studentName == studentName &&
        other.registrationNo == registrationNo &&
        other.course == course &&
        other.branch == branch &&
        other.tenthCollegeName == tenthCollegeName &&
        other.tenthCertificateUrl == tenthCertificateUrl &&
        other.tenthCgpaOrPercentage == tenthCgpaOrPercentage &&
        other.twelfthCollegeName == twelfthCollegeName &&
        other.twelfthCertificateUrl == twelfthCertificateUrl &&
        other.twelfthCgpaOrPercentage == twelfthCgpaOrPercentage &&
        other.graduationCollegeName == graduationCollegeName &&
        other.graduationCertificateUrl == graduationCertificateUrl &&
        other.graduationCgpaOrPercentage == graduationCgpaOrPercentage &&
        other.mastersCollegeName == mastersCollegeName &&
        other.mastersCertificateUrl == mastersCertificateUrl &&
        other.mastersCgpaOrPercentage == mastersCgpaOrPercentage &&
        other.undertakingDescription == undertakingDescription &&
        other.undertakingDate == undertakingDate &&
        other.signatureUrl == signatureUrl &&
        other.isSelected == isSelected &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return applicationId.hashCode ^
    sessionId.hashCode ^
    companyId.hashCode ^
    companyName.hashCode ^
    jobTitle.hashCode ^
    studentName.hashCode ^
    registrationNo.hashCode ^
    course.hashCode ^
    branch.hashCode ^
    tenthCollegeName.hashCode ^
    tenthCertificateUrl.hashCode ^
    tenthCgpaOrPercentage.hashCode ^
    twelfthCollegeName.hashCode ^
    twelfthCertificateUrl.hashCode ^
    twelfthCgpaOrPercentage.hashCode ^
    graduationCollegeName.hashCode ^
    graduationCertificateUrl.hashCode ^
    graduationCgpaOrPercentage.hashCode ^
    mastersCollegeName.hashCode ^
    mastersCertificateUrl.hashCode ^
    mastersCgpaOrPercentage.hashCode ^
    undertakingDescription.hashCode ^
    undertakingDate.hashCode ^
    signatureUrl.hashCode ^
    isSelected.hashCode ^
    createdAt.hashCode;
  }
}
