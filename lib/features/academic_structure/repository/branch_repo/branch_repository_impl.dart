import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';

class BranchRepositoryImpl extends BranchRepository {
  final FirebaseFirestore _firestore;
  BranchRepositoryImpl(this._firestore);

  @override
  Future<Either<AppFailure, Unit>> addNewBranch(
    Branch branch,
    String collegeId,
  ) async {
    try {
      await _firestore
          .collection('branches')
          .doc(collegeId)
          .collection("branches")
          .doc(branch.branchId)
          .set(branch.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteBranch(
    Branch branch,
    String collegeId,
  ) async {
    try {
      await _firestore.collection('branches')
          .doc(collegeId)
          .collection("branches")
          .doc(branch.branchId)
          .delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Branch>>> loadAllBranches(
    String collegeId,
  ) async {
    try {
      final snapshot = await _firestore.collection('branches')
          .doc(collegeId)
          .collection("branches")
          .get();
      final branches = snapshot.docs
          .map((doc) => Branch.fromMap(doc.data()))
          .toList();
      return Right(branches);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateBranch(
    Branch branch,
    String collegeId,
  ) async {
    try {
      await _firestore
          .collection('branches')
          .doc(collegeId)
          .collection("branches")
          .doc(branch.branchId)
          .update(branch.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
