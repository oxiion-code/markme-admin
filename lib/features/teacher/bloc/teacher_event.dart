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
  const AddTeacherEvent(this.teacher);
}

class UpdateTeacherEvent extends TeacherEvent{
  final Teacher teacher;
  const UpdateTeacherEvent(this.teacher);
  @override
  // TODO: implement props
  List<Object?> get props => [teacher];
}

class DeleteTeacherEvent extends TeacherEvent{
  final Teacher teacher;
  const DeleteTeacherEvent(this.teacher);
  @override
  // TODO: implement props
  List<Object?> get props => [teacher];
}

class LoadTeachersEvent extends TeacherEvent{}
class LoadBranchesForTeacherEvent extends TeacherEvent{}