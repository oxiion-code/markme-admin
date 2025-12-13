class BranchSeatAllocation {
  final String allocationId;
  final String courseId;
  final String branchId;
  final String year;
  final int totalSeats;
  final int availableSeats;
  final String createdAt;

  BranchSeatAllocation({
    required this.allocationId,
    required this.courseId,
    required this.branchId,
    required this.year,
    required this.totalSeats,
    required this.availableSeats,
    required this.createdAt,
  });

  BranchSeatAllocation copyWith({
    String? allocationId,
    String? courseId,
    String? branchId,
    String? year,
    int? totalSeats,
    int? availableSeats,
    String? createdAt,
  }) {
    return BranchSeatAllocation(
      allocationId: allocationId ?? this.allocationId,
      courseId: courseId ?? this.courseId,
      branchId: branchId ?? this.branchId,
      year: year ?? this.year,
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "allocationId": allocationId,
      "courseId": courseId,
      "branchId": branchId,
      "year": year,
      "totalSeats": totalSeats,
      "availableSeats": availableSeats,
      "createdAt": createdAt,
    };
  }

  factory BranchSeatAllocation.fromMap(Map<String, dynamic> map) {
    return BranchSeatAllocation(
      allocationId: map["allocationId"],
      courseId: map["courseId"],
      branchId: map["branchId"],
      year: map["year"],
      totalSeats: map["totalSeats"],
      availableSeats: map["availableSeats"],
      createdAt: map["createdAt"],
    );
  }
}
