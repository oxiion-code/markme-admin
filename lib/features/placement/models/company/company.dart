// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import "package:collection/collection.dart" show DeepCollectionEquality;

class Company {
  final String companyId;
  final String name;
  final String logoUrl;
  final String description;
  final List<String> jobRoles;
  final String location;
  final String createdAt;
  final List<String> sessionIds; // <-- added field

  const Company({
    required this.companyId,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.jobRoles,
    required this.location,
    required this.createdAt,
    required this.sessionIds, // <-- added param
  });

  Company copyWith({
    String? companyId,
    String? name,
    String? logoUrl,
    String? description,
    List<String>? jobRoles,
    String? location,
    String? createdAt,
    List<String>? sessionIds,
  }) {
    return Company(
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      jobRoles: jobRoles ?? this.jobRoles,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      sessionIds: sessionIds ?? this.sessionIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyId': companyId,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'jobRoles': jobRoles,
      'location': location,
      'createdAt': createdAt,
      'sessionIds': sessionIds, // added
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      companyId: map['companyId'] as String,
      name: map['name'] as String,
      logoUrl: map['logoUrl'] as String,
      description: map['description'] as String,
      jobRoles: List<String>.from(map['jobRoles'] ?? []),
      location: map['location'] as String,
      createdAt: map['createdAt'] as String,
      sessionIds: List<String>.from(map['sessionIds'] ?? []), // added
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Company(companyId: $companyId, name: $name, logoUrl: $logoUrl, description: $description, jobRoles: $jobRoles, location: $location, createdAt: $createdAt, sessionIds: $sessionIds)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    final listEquals = const DeepCollectionEquality().equals;

    return other.companyId == companyId &&
        other.name == name &&
        other.logoUrl == logoUrl &&
        other.description == description &&
        listEquals(other.jobRoles, jobRoles) &&
        other.location == location &&
        other.createdAt == createdAt &&
        listEquals(other.sessionIds, sessionIds);
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
    name.hashCode ^
    logoUrl.hashCode ^
    description.hashCode ^
    jobRoles.hashCode ^
    location.hashCode ^
    createdAt.hashCode ^
    sessionIds.hashCode;
  }
}
