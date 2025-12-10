import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/teacher/models/teacher.dart';

abstract class TeacherRepository{
  Future<Either<AppFailure,Unit>> addTeacher(Teacher teacher,String collegeId);
  Future<Either<AppFailure,Unit>> updateTeacher(Teacher teacher,String collegeId);
  Future<Either<AppFailure,Unit>> deleteTeacher(Teacher teacher,String collegeId);
  Future<Either<AppFailure,List<Teacher>>> getTeachers(String collegeId);
  Future<Either<AppFailure, List<Teacher>>> getTeachersForBranch(String branchId,String collegeId);
}