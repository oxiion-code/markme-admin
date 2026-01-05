import '../../../data/models/student.dart';

class StudentVerificationArgs {
  final String collegeId;
  final Student student;

  StudentVerificationArgs({
    required this.collegeId,
    required this.student,
  });
}
