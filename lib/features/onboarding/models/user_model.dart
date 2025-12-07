import 'dart:convert';

class AdminUser {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String role;
  final String collegeId;
  final String collegeName;
  final String designation;
  final String adminType;
  final String joinedAt;
  final String profilePhotoUrl;
  final String deviceToken;
  final String? bannerLink;

  const AdminUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.collegeId,
    required this.collegeName,
    required this.designation,
    required this.adminType,
    required this.joinedAt,
    required this.profilePhotoUrl,
    required this.deviceToken,
    this.bannerLink,
  });

  AdminUser copyWith({
    String? uid,
    String? name,
    String? phone,
    String? email,
    String? role,
    String? collegeId,
    String? collegeName,
    String? designation,
    String? adminType,
    String? joinedAt,
    String? profilePhotoUrl,
    String? deviceToken,
    String? bannerLink,
  }) {
    return AdminUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      collegeId: collegeId ?? this.collegeId,
      collegeName: collegeName ?? this.collegeName,
      designation: designation ?? this.designation,
      adminType: adminType ?? this.adminType,
      joinedAt: joinedAt ?? this.joinedAt,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      deviceToken: deviceToken ?? this.deviceToken,
      bannerLink: bannerLink ?? this.bannerLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'collegeId': collegeId,
      'collegeName': collegeName,
      'designation': designation,
      'adminType': adminType,
      'joinedAt': joinedAt,
      'profilePhotoUrl': profilePhotoUrl,
      'deviceToken': deviceToken,
      'bannerLink': bannerLink,
    };
  }

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      collegeId: map['collegeId'] ?? '',
      collegeName: map['collegeName'] ?? '',
      designation: map['designation'] ?? '',
      adminType: map['adminType'] ?? '',
      joinedAt: map['joinedAt'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      bannerLink: map['bannerLink'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminUser.fromJson(String source) =>
      AdminUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminUser(uid: $uid, name: $name, phone: $phone, email: $email, role: $role, '
        'collegeId: $collegeId, collegeName: $collegeName, designation: $designation, '
        'adminType: $adminType, joinedAt: $joinedAt, profilePhotoUrl: $profilePhotoUrl, '
        'deviceToken: $deviceToken, bannerLink: $bannerLink)';
  }

  @override
  bool operator ==(covariant AdminUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.role == role &&
        other.collegeId == collegeId &&
        other.collegeName == collegeName &&
        other.designation == designation &&
        other.adminType == adminType &&
        other.joinedAt == joinedAt &&
        other.profilePhotoUrl == profilePhotoUrl &&
        other.deviceToken == deviceToken &&
        other.bannerLink == bannerLink;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        role.hashCode ^
        collegeId.hashCode ^
        collegeName.hashCode ^
        designation.hashCode ^
        adminType.hashCode ^
        joinedAt.hashCode ^
        profilePhotoUrl.hashCode ^
        deviceToken.hashCode ^
        bannerLink.hashCode;
  }
}
