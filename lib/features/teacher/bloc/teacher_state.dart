import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/teacher/models/teacher.dart';

class TeacherState extends Equatable{
  const TeacherState();
  @override
  List<Object?> get props => [];
}
class TeacherLoading extends TeacherState{

}
class TeacherInitial extends TeacherState{

}
class TeacherSuccess extends TeacherState{

}

class TeachersLoaded extends TeacherState{
  final List<Teacher> teachers;
  const TeachersLoaded(this.teachers);
  @override
  List<Object?> get props => [teachers];
}

class LoadBranchesForTeacher extends TeacherState{
  final List<Branch> branches;
  const LoadBranchesForTeacher(this.branches);
  @override
  List<Object?> get props => [branches];
}

class TeacherError extends TeacherState{
  final String message;
  const TeacherError(this.message);
  @override
  List<Object?> get props => [message];
}