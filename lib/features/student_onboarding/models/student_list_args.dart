import 'package:markme_admin/features/academic_structure/models/section.dart';

import '../../../data/models/student.dart';

class StudentListArgs {
  final String collegeId;
  final List<Student> students;
  final String? sectionId;
  final Section? section;

  StudentListArgs({
    required this.collegeId,
    required this.students,
    this.sectionId,
    this.section
  });
}
