import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

abstract class SemesterState extends Equatable{
  const SemesterState();
  @override
  List<Object?> get props => [];
}

class SemesterInitial extends SemesterState{}

class SemesterSuccess extends SemesterState{}

class SemesterLoading extends SemesterState{}

class SemesterFailure extends SemesterState{
  final String message;
  const SemesterFailure(this.message);
  @override
  List<Object?> get props => [message];
}
class SemestersLoaded extends SemesterState{
  final List<Semester> semesters;
  const SemestersLoaded(this.semesters);
  @override
  List<Object?> get props => [];
}
class CoursesLoaded extends SemesterState{
  final List<Course> courses;
  const CoursesLoaded(this.courses);
  @override
  List<Object?> get props => [courses];
}