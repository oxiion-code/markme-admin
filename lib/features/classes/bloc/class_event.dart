import 'package:equatable/equatable.dart';

import '../models/class_info.dart';

class ClassEvent extends Equatable {
  const ClassEvent();
  @override
  List<Object?> get props => [];
}

class AddClassEvent extends ClassEvent {
  final ClassInfo classInfo;
  const AddClassEvent(this.classInfo);
  @override
  List<Object?> get props => [classInfo];
}

class UpdateClassEvent extends ClassEvent {
  final ClassInfo classInfo;
  const UpdateClassEvent(this.classInfo);
  @override
  List<Object?> get props => [classInfo];
}

class DeleteClassEvent extends ClassEvent {
  final String classId;
  const DeleteClassEvent(this.classId);
  @override
  List<Object?> get props => [classId];
}

class GetAllClassesEvent extends ClassEvent {}

class GetAllClassesForTeacherEvent extends ClassEvent {
  final String teacherId;
  const GetAllClassesForTeacherEvent(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

// Dropdown related events
class GetAllCoursesForClassEvent extends ClassEvent {}

class GetBranchesForCourseInClassEvent extends ClassEvent {
  final String courseId;
  const GetBranchesForCourseInClassEvent(this.courseId);
  @override
  List<Object?> get props => [courseId];
}

class GetBatchesForBranchInClassEvent extends ClassEvent {
  final String branchId;
  const GetBatchesForBranchInClassEvent(this.branchId);
  @override
  List<Object?> get props => [branchId];
}
