// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class AuthInfo {
  final String uid;
  final String phoneNumber;
  final String? collegeId;
  final String? collegeName;
  final String? bannerLink;
  const AuthInfo({
    required this.uid,
    required this.phoneNumber,
    this.collegeId,
    this.collegeName,
    this.bannerLink
  });

  AuthInfo copyWith({
    String? uid,
    String? phoneNumber,
    String? collegeId,
    String? collegeName,
    String? bannerLink,
  }) {
    return AuthInfo(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      collegeId: collegeId ?? this.collegeId,
      collegeName: collegeName ?? this.collegeName,
      bannerLink: bannerLink ?? this.bannerLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'phoneNumber': phoneNumber,
      'collegeId': collegeId,
      'collegeName': collegeName,
      'bannerLink': bannerLink,
    };
  }

  factory AuthInfo.fromMap(Map<String, dynamic> map) {
    return AuthInfo(
      uid: map['uid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      collegeId: map['collegeId'] != null ? map['collegeId'] as String : null,
      collegeName: map['collegeName'] != null ? map['collegeName'] as String : null,
      bannerLink: map['bannerLink'] != null ? map['bannerLink'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthInfo.fromJson(String source) => AuthInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthInfo(uid: $uid, phoneNumber: $phoneNumber, collegeId: $collegeId, collegeName: $collegeName, bannerLink: $bannerLink)';
  }

  @override
  bool operator ==(covariant AuthInfo other) {
    if (identical(this, other)) return true;

    return
      other.uid == uid &&
          other.phoneNumber == phoneNumber &&
          other.collegeId == collegeId &&
          other.collegeName == collegeName &&
          other.bannerLink == bannerLink;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
    phoneNumber.hashCode ^
    collegeId.hashCode ^
    collegeName.hashCode ^
    bannerLink.hashCode;
  }
}
