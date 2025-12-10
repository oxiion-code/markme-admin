import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';

abstract class AcademicBatchRepository{
  Future<Either<AppFailure,Unit>> addBatch(AcademicBatch batch,String collegeId);
  Future<Either<AppFailure,Unit>> updateBatch(AcademicBatch batch,String collegeId);
  Future<Either<AppFailure,Unit>> deleteBatch(AcademicBatch batch,String collegeId);
  Future<Either<AppFailure,List<AcademicBatch>>> getBatches(String branchId,String collegeId);
}