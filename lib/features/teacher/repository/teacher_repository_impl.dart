import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/teacher/models/teacher.dart';
import 'package:markme_admin/features/teacher/repository/teacher_repository.dart';

class TeacherRepositoryImpl extends TeacherRepository {
  FirebaseFirestore firestore;
  TeacherRepositoryImpl(this.firestore);
  @override
  Future<Either<AppFailure, Unit>> addTeacher(
    Teacher teacher,
    String collegeId,
  ) async {
    try {
      await firestore
          .collection("teachers")
          .doc(collegeId)
          .collection("teachers")
          .doc(teacher.teacherId)
          .set(teacher.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteTeacher(
    Teacher teacher,
    String collegeId,
  ) async {
    try {
      await firestore
          .collection("teachers")
          .doc(collegeId)
          .collection("teachers")
          .doc(teacher.teacherId).delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Teacher>>> getTeachers(
    String collegeId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("teachers")
          .doc(collegeId)
          .collection("teachers")
          .get();
      final teachers = snapshot.docs
          .map((doc) => Teacher.fromMap(doc.data()))
          .toList();
      return Right(teachers);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Teacher>>> getTeachersForBranch(
    String branchId,
    String collegeId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("teachers")
          .doc(collegeId)
          .collection("teachers")
          .where("branchId", isEqualTo: branchId)
          .get();
      final teachers = snapshot.docs
          .map((doc) => Teacher.fromMap(doc.data()))
          .toList();
      return Right(teachers);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateTeacher(
    Teacher teacher,
    String collegeId,
  ) async {
    try {
      await firestore
          .collection("teachers")
          .doc(collegeId)
          .collection("teachers")
          .doc(teacher.teacherId)
          .update(teacher.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
