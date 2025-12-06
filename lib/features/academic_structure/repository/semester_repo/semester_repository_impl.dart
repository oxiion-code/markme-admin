import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';
import 'package:markme_admin/features/academic_structure/repository/semester_repo/semester_repository.dart';

class SemesterRepositoryImpl extends SemesterRepository {
  final FirebaseFirestore _firestore;
  SemesterRepositoryImpl(this._firestore);

  @override
  Future<Either<AppFailure, Unit>> addSemester(Semester semester) async {
    try {
      await _firestore
          .collection('semesters')
          .doc(semester.semesterId)
          .set(semester.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteSemester(Semester semester) async {
    try {
      await _firestore
          .collection('semesters')
          .doc(semester.semesterId)
          .delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Semester>>> getSemesters(
    String courseId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('semesters')
          .where("courseId", isEqualTo: courseId)
          .get();
      final semesters = snapshot.docs
          .map((semester) => Semester.fromMap(semester.data()))
          .toList();
      return Right(semesters);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateSemester(Semester semester) async {
    try {
      await _firestore
          .collection('semesters')
          .doc(semester.semesterId)
          .update(semester.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
