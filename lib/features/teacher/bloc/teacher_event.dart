import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/teacher/models/teacher.dart';

class TeacherEvent extends Equatable{
  const TeacherEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddTeacherEvent extends TeacherEvent{
  final Teacher teacher ;
  final String collegeId;
  const AddTeacherEvent({required this.collegeId, required this.teacher});
}

class UpdateTeacherEvent extends TeacherEvent{
  final Teacher teacher;
  final String collegeId;
  const UpdateTeacherEvent({required this.teacher, required this.collegeId});
  @override
  List<Object?> get props => [teacher];
}

class DeleteTeacherEvent extends TeacherEvent{
  final Teacher teacher;
  final String collegeId;
  const DeleteTeacherEvent({required this.teacher, required this.collegeId});
  @override
  List<Object?> get props => [teacher];
}

class LoadTeachersEvent extends TeacherEvent{
  final String collegeId;
  const LoadTeachersEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
class LoadBranchesForTeacherEvent extends TeacherEvent{
  final String collegeId;
  const LoadBranchesForTeacherEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}