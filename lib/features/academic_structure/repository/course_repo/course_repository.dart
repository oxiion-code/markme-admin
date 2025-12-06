import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';

import '../../models/course.dart';

abstract class CourseRepository{
  Future<Either<AppFailure,List<Course>>> getCourses();
  Future<Either<AppFailure,Unit>> addCourse(Course course);
  Future<Either<AppFailure,Unit>> updateCourse(Course course);
  Future<Either<AppFailure,Unit>> deleteCourse(Course course);
}