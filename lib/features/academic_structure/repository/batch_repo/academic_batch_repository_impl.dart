import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';

class AcademicBatchRepositoryImpl extends AcademicBatchRepository {
  final FirebaseFirestore _firestore;

  AcademicBatchRepositoryImpl(this._firestore);

  @override
  Future<Either<AppFailure, Unit>> addBatch(
    AcademicBatch batch,
    String collegeId,
  ) async {
    try {
      await _firestore
          .collection('academicBatches')
          .doc(collegeId)
          .collection('academicBatches')
          .doc(batch.batchId)
          .set(batch.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteBatch(
    AcademicBatch batch,
    String collegeId,
  ) async {
    try {
      await _firestore
          .collection('academicBatches')
          .doc(collegeId)
          .collection('academicBatches')
          .doc(batch.batchId)
          .delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<AcademicBatch>>> getBatches(
    String branchId,
    String collegeId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('academicBatches')
          .doc(collegeId)
          .collection('academicBatches')
          .where("branchId", isEqualTo: branchId)
          .get();
      final batches = snapshot.docs
          .map((doc) => AcademicBatch.fromMap(doc.data()))
          .toList();
      return Right(batches);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateBatch(
    AcademicBatch batch,
    String collegeId,
  ) async {
    try {
      await _firestore
          .collection('academicBatches')
          .doc(collegeId)
          .collection('academicBatches')
          .doc(batch.batchId)
          .update(batch.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
