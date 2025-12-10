import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

abstract class SemesterEvent extends Equatable{
  const SemesterEvent();
  @override
  List<Object?> get props => [];
}
class AddNewSemesterEvent extends SemesterEvent{
  final Semester semester;
  final String collegeId;
  const AddNewSemesterEvent(this.semester,this.collegeId);
  @override
  List<Object?> get props => [semester,collegeId];
}

class UpdateSemesterEvent extends SemesterEvent{
  final Semester semester;
  final String collegeId;
  const UpdateSemesterEvent(this.semester,this.collegeId);
  @override
  List<Object?> get props => [semester,collegeId];
}

class DeleteSemesterEvent extends SemesterEvent{
  final Semester semester;
  final String collegeId;
  const DeleteSemesterEvent(this.semester, this.collegeId);
  @override
  List<Object?> get props => [semester,collegeId];
}

class LoadCoursesEvent extends SemesterEvent{
  final String collegeId;
  const LoadCoursesEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
class LoadSemestersEvent extends SemesterEvent{
  final String courseId;
  final String collegeId;
  const LoadSemestersEvent({required this.courseId,required this.collegeId});
  @override
  List<Object?> get props => [courseId];
}