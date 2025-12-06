import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';

class CourseEvent extends Equatable{
  const CourseEvent();
  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent{}

class AddCourseEvent extends CourseEvent{
  final Course course;
  const AddCourseEvent(this.course);
  @override
  List<Object?> get props => [course];
}

class UpdateCourseEvent extends CourseEvent{
  final Course course;
  const UpdateCourseEvent(this.course);

  @override
  List<Object?> get props => [course];
}

class DeleteCourseEvent extends CourseEvent{
  final Course course;
  const DeleteCourseEvent(this.course);

  @override
  List<Object?> get props => [course];
}