class Eligibility {
  final List<String> branches;
  final List<String> batches;
  final double minCgpa;
  final int maxBacklogs;

  const Eligibility({
    required this.branches,
    required this.batches,
    required this.minCgpa,
    required this.maxBacklogs,
  });

  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      branches: List<String>.from(json['branches'] ?? []),
      batches: List<String>.from(json['batches'] ?? []),
      minCgpa: (json['minCgpa'] ?? 0).toDouble(),
      maxBacklogs: json['maxBacklogs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branches': branches,
      'batches': batches,
      'minCgpa': minCgpa,
      'maxBacklogs': maxBacklogs,
    };
  }
}
