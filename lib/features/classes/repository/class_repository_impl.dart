import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/features/classes/models/class_session.dart';

import '../../../core/error/failure.dart';
import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../../academic_structure/models/course.dart';
import '../models/class_info.dart';
import 'class_repository.dart';

class ClassRepositoryImpl extends ClassRepository {
  final FirebaseFirestore firestore;
  ClassRepositoryImpl(this.firestore);

  @override
  Future<Either<AppFailure, Unit>> addClass(ClassInfo classInfo) async {
    try {
      await firestore
          .collection('classes')
          .doc(classInfo.classId)
          .set(classInfo.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateClass(ClassInfo classInfo) async {
    try {
      await firestore
          .collection('classes')
          .doc(classInfo.classId)
          .update(classInfo.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteClass(String classId) async {
    try {
      await firestore.collection('classes').doc(classId).delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<ClassInfo>>> getAllClasses() async {
    try {
      final snapshot = await firestore.collection('classes').get();
      final classes = snapshot.docs
          .map((doc) => ClassInfo.fromMap(doc.data()))
          .toList();
      return Right(classes);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<ClassInfo>>> getClassesForTeacher(
    String teacherId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('classes')
          .where('teacherId', isEqualTo: teacherId)
          .get();
      final classes = snapshot.docs
          .map((doc) => ClassInfo.fromMap(doc.data()))
          .toList();
      return Right(classes);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Course>>> getAllCourses() async {
    try {
      final snapshot = await firestore.collection('courses').get();
      final courses = snapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
      return Right(courses);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Branch>>> getBranchesForCourse(
    String courseId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('branches')
          .where('courseId', isEqualTo: courseId)
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
  Future<Either<AppFailure, List<AcademicBatch>>> getBatchesForBranch(
    String branchId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('academicBatches')
          .where('branchId', isEqualTo: branchId)
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
  Stream<Either<AppFailure, List<ClassSession>>> getCurrentDayClasses() {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(
        now.year,
        now.month,
        now.day,
      ).millisecondsSinceEpoch;
      final endOfDay = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      ).millisecondsSinceEpoch;

      return firestore
          .collection('classSessions')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .snapshots()
          .map((snapshot) {
            final sessions = snapshot.docs.map((doc) {
              return ClassSession.fromMap(doc.data());
            }).toList();
            return Right<AppFailure, List<ClassSession>>(sessions);
          })
          .handleError((error) {
            return Left<AppFailure, List<ClassSession>>(
              AppFailure(message: error.toString()),
            );
          });
    } catch (e) {
      return Stream.value(Left(AppFailure(message: e.toString())));
    }
  }
}
