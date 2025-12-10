import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';

class CourseEvent extends Equatable{
  const CourseEvent();
  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent{
  final String collegeId;
  const LoadCourses({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}

class AddCourseEvent extends CourseEvent{
  final Course course;
  final String collegeId;
  const AddCourseEvent({required this.course, required this.collegeId});
  @override
  List<Object?> get props => [course];
}

class UpdateCourseEvent extends CourseEvent{
  final Course course;
  final String collegeId;
  const UpdateCourseEvent({required this.collegeId, required this.course});

  @override
  List<Object?> get props => [course,collegeId];
}

class DeleteCourseEvent extends CourseEvent{
  final Course course;
  final String collegeId;
  const DeleteCourseEvent({required this.course, required this.collegeId});

  @override
  List<Object?> get props => [course,collegeId];
}