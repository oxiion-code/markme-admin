import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

abstract class BranchRepository{
  Future<Either<AppFailure,Unit>> addNewBranch(Branch branch,String collegeId);
  Future<Either<AppFailure,Unit>> updateBranch(Branch branch,String collegeId);
  Future<Either<AppFailure,Unit>> deleteBranch(Branch branch,String collegeId);
  Future<Either<AppFailure,List<Branch>>> loadAllBranches(String collegeId);
}