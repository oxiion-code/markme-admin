import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/subjects/models/subject.dart';

abstract class SubjectRepository{
  Future<Either<AppFailure,Unit>> addSubject(Subject subject);
  Future<Either<AppFailure,Unit>> updateSubject(Subject subject);
  Future<Either<AppFailure,Unit>> deleteSubject(Subject subject);
  Future<Either<AppFailure,List<Subject>>> getSubjects();
}