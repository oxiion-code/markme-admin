class Subject {
  final String subjectId;
  final String subjectName;
  final String batchId;
  final String branchId;
  final String subjectCode;
  final String subjectType;

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.batchId,
    required this.branchId,
    required this.subjectCode,
    required this.subjectType,
  });

  // COPY WITH
  Subject copyWith({
    String? subjectId,
    String? subjectName,
    String? batchId,
    String? branchId,
    String? subjectCode,
    String? subjectType,
  }) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectType: subjectType ?? this.subjectType,
    );
  }

  // TO MAP
  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'batchId': batchId,
      'branchId': branchId,
      'subjectCode': subjectCode,
      'subjectType': subjectType,
    };
  }

  // FROM MAP
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subjectId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      batchId: map['batchId'] ?? '',
      branchId: map['branchId'] ?? '',
      subjectCode: map['subjectCode'] ?? '',
      subjectType: map['subjectType'] ?? '',
    );
  }

  // TO JSON
  String toJson() => toMap().toString();

  // FROM JSON
  factory Subject.fromJson(Map<String, dynamic> json) => Subject.fromMap(json);

  // EQUALITY
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subject &&
        other.subjectId == subjectId &&
        other.subjectName == subjectName &&
        other.batchId == batchId &&
        other.branchId == branchId &&
        other.subjectCode == subjectCode &&
        other.subjectType == subjectType;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
    subjectName.hashCode ^
    batchId.hashCode ^
    branchId.hashCode ^
    subjectCode.hashCode ^
    subjectType.hashCode;
  }

  @override
  String toString() {
    return 'Subject(subjectId: $subjectId, subjectName: $subjectName, batchId: $batchId, branchId: $branchId, subjectCode: $subjectCode, subjectType: $subjectType)';
  }
}
