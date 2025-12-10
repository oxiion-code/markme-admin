import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

abstract class SemesterRepository{
  Future<Either<AppFailure,Unit>> addSemester(Semester semester,String collegeId) ;
  Future<Either<AppFailure,Unit>> updateSemester(Semester semester,String collegeId);
  Future<Either<AppFailure,Unit>> deleteSemester(Semester semester,String collegeId);
  Future<Either<AppFailure,List<Semester>>> getSemesters(String courseId,String collegeId);
}