import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/subjects/models/subject.dart';

abstract class SubjectRepository{
  Future<Either<AppFailure,Unit>> addSubject(Subject subject,String collegeId);
  Future<Either<AppFailure,Unit>> updateSubject(Subject subject,String collegeId);
  Future<Either<AppFailure,Unit>> deleteSubject(Subject subject,String collegeId);
  Future<Either<AppFailure,List<Subject>>> getSubjects(String collegeId,String branchId);
}