import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';

abstract class SectionRepository{
  Future<Either<AppFailure,Unit>> addSection(Section section,String collegeId);
  Future<Either<AppFailure,Unit>> updateSection(Section section,String collegeId);
  Future<Either<AppFailure,Unit>> deleteSection(Section section,String collegeId);
  Future<Either<AppFailure,List<Section>>> getAllSections(String branchId,String collegeId);
}