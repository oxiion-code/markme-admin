// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class CollegeDetail {
  final String? collegeBanner;
  final String collegeName;
  final bool isSuperAdminExist;
  final String? logo;
  final String id;
  const CollegeDetail({
    this.collegeBanner,
    required this.collegeName,
    required this.isSuperAdminExist,
    this.logo,
    required this.id
  });

  CollegeDetail copyWith({
    String? collegeBanner,
    String? collegeName,
    bool? isSuperAdminExist,
    String? logo,
    required String id,
  }) {
    return CollegeDetail(
      collegeBanner: collegeBanner ?? this.collegeBanner,
      collegeName: collegeName ?? this.collegeName,
      isSuperAdminExist: isSuperAdminExist ?? this.isSuperAdminExist,
      logo: logo ?? this.logo,
      id: id ,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'collegeBanner': collegeBanner,
      'collegeName': collegeName,
      'isSuperAdminExist': isSuperAdminExist,
      'logo': logo,
      'id': id,
    };
  }

  factory CollegeDetail.fromMap(Map<String, dynamic> map) {
    return CollegeDetail(
      collegeBanner: map['collegeBanner'] != null ? map['collegeBanner'] as String : null,
      collegeName: map['collegeName'] as String,
      isSuperAdminExist: map['isSuperAdminExist'] as bool,
      logo: map['logo'] != null ? map['logo'] as String : null,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollegeDetail.fromJson(String source) => CollegeDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CollegeDetail(collegeBanner: $collegeBanner, collegeName: $collegeName, isSuperAdminExist: $isSuperAdminExist, logo: $logo, id: $id)';
  }

  @override
  bool operator ==(covariant CollegeDetail other) {
    if (identical(this, other)) return true;

    return
      other.collegeBanner == collegeBanner &&
          other.collegeName == collegeName &&
          other.isSuperAdminExist == isSuperAdminExist &&
          other.logo == logo &&
          other.id == id;
  }

  @override
  int get hashCode {
    return collegeBanner.hashCode ^
    collegeName.hashCode ^
    isSuperAdminExist.hashCode ^
    logo.hashCode ^
    id.hashCode;
  }
}
