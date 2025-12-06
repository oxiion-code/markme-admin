import 'package:markme_admin/data/models/student.dart';

class StudentWithStatus{
  final Student student;
  final bool isPresent;
  StudentWithStatus({required this.student, required this.isPresent});
}