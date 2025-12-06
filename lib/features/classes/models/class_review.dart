import 'dart:convert';

class ClassReview {
  final String studentId;
  final String comment;
  final double rating; // from 1.0 to 5.0
  final DateTime submittedAt;

  ClassReview({
    required this.studentId,
    required this.comment,
    required this.rating,
    required this.submittedAt,
  });

  ClassReview copyWith({
    String? studentId,
    String? comment,
    double? rating,
    DateTime? submittedAt,
  }) {
    return ClassReview(
      studentId: studentId ?? this.studentId,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentId': studentId,
      'comment': comment,
      'rating': rating,
      'submittedAt': submittedAt.millisecondsSinceEpoch,
    };
  }

  factory ClassReview.fromMap(Map<String, dynamic> map) {
    return ClassReview(
      studentId: map['studentId'] as String,
      comment: map['comment'] as String,
      rating: map['rating'] as double,
      submittedAt: DateTime.fromMillisecondsSinceEpoch(map['submittedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassReview.fromJson(String source) => ClassReview.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassReview(studentId: $studentId, comment: $comment, rating: $rating, submittedAt: $submittedAt)';
  }

  @override
  bool operator ==(covariant ClassReview other) {
    if (identical(this, other)) return true;

    return
      other.studentId == studentId &&
          other.comment == comment &&
          other.rating == rating &&
          other.submittedAt == submittedAt;
  }

  @override
  int get hashCode {
    return studentId.hashCode ^
    comment.hashCode ^
    rating.hashCode ^
    submittedAt.hashCode;
  }
}
