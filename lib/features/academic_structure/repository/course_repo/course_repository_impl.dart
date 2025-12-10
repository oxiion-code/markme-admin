import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';

class CourseRepositoryImpl extends CourseRepository {
  final FirebaseFirestore _firebaseFirestore;
  CourseRepositoryImpl(this._firebaseFirestore);
  @override
  Future<Either<AppFailure, Unit>> addCourse(
    Course course,
    String collegeId,
  ) async {
    try {
      await _firebaseFirestore
          .collection('courses')
          .doc(collegeId)
          .collection('courses')
          .doc(course.courseId)
          .set(course.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteCourse(
    Course course,
    String collegeId,
  ) async {
    try {
      await _firebaseFirestore
          .collection('courses')
          .doc(collegeId)
          .collection('courses')
          .doc(course.courseId)
          .delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Course>>> getCourses(String collegeId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('courses')
          .doc(collegeId)
          .collection('courses')
          .get();
      final courses = snapshot.docs
          .map((doc) => Course.fromMap(doc.data()))
          .toList();
      return Right(courses);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateCourse(
    Course course,
    String collegeId,
  ) async {
    try {
      await _firebaseFirestore
          .collection('courses')
          .doc(collegeId)
          .collection('courses')
          .doc(course.courseId)
          .update(course.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
