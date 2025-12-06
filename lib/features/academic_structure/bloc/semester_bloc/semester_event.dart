import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

abstract class SemesterEvent extends Equatable{
  const SemesterEvent();
  @override
  List<Object?> get props => [];
}
class AddNewSemesterEvent extends SemesterEvent{
  final Semester semester;
  const AddNewSemesterEvent(this.semester);
  @override
  List<Object?> get props => [semester];
}

class UpdateSemesterEvent extends SemesterEvent{
  final Semester semester;
  const UpdateSemesterEvent(this.semester);
  @override
  List<Object?> get props => [semester];
}

class DeleteSemesterEvent extends SemesterEvent{
  final Semester semester;
  const DeleteSemesterEvent(this.semester);
  @override
  List<Object?> get props => [semester];
}

class LoadCoursesEvent extends SemesterEvent{
}
class LoadSemestersEvent extends SemesterEvent{
  final String courseId;
  const LoadSemestersEvent({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}