import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';

abstract class SectionRepository{
  Future<Either<AppFailure,Unit>> addSection(Section section);
  Future<Either<AppFailure,Unit>> updateSection(Section section);
  Future<Either<AppFailure,Unit>> deleteSection(Section section);
  Future<Either<AppFailure,List<Section>>> getAllSections(String branchId);
}