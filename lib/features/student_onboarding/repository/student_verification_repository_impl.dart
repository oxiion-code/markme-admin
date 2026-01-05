import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/data/models/student.dart';
import 'package:markme_admin/features/student_onboarding/models/qualification.dart';
import 'package:markme_admin/features/student_onboarding/repository/student_verification_repository.dart';

class StudentVerificationRepositoryImpl extends StudentVerificationRepository {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  StudentVerificationRepositoryImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<Either<AppFailure, List<Student>>> getStudentsForVerification(
      String collegeId,
      String batchId,) async {
    try {
      final querySnapshot = await firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .where("batchId", isEqualTo: batchId)
          .where("isProfileVerified", isEqualTo: "both_uploaded")
          .get();
      final students = querySnapshot.docs
          .map((doc) => Student.fromJson({...doc.data()}))
          .toList();

      return Right(students);
    } catch (e) {
      return Left(
        AppFailure(message: 'Failed to fetch students for verification'),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markStudentVerificationFail(String collegeId,
      String studentId,
      String message,) async {
    try {
      final studentDocRef = firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .doc(studentId);

      await studentDocRef.update({
        'isProfileVerified':
        "failed_$message", // <-- failure reason stored here
      });
      return const Right(unit);
    } catch (e) {
      return Left(
        AppFailure(message: 'Failed to mark student verification as failed'),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markStudentVerified(String collegeId,
      String studentId,) async {
    try {
      final studentDocRef = firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .doc(studentId);

      await studentDocRef.update({'isProfileVerified': 'verified'});
      return const Right(unit);
    } catch (e) {
      return Left(AppFailure(message: 'Failed to mark student as verified'));
    }
  }

  @override
  Future<Either<AppFailure, List<Qualification>>> loadStudentQualification(
      String collegeId,
      String studentId,) async {
    try {
      final querySnapshot = await firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .doc(studentId)
          .collection("qualification_details")
          .get();

      final List<Qualification> qualifications = querySnapshot.docs
          .map((doc) => Qualification.fromMap(doc.data()))
          .toList();

      return Right(qualifications);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Student>>> getStudentsForSectionAllotment(
      String collegeId,
      String batchId,) async {
    try {
      final querySnapshot = await firestore
          .collection("students")
          .doc(collegeId)
          .collection("students")
          .where("batchId", isEqualTo: batchId)
          .where("isProfileVerified", isEqualTo: "verified")
          .where("sectionId", isEqualTo: "")
          .get();

      final students = querySnapshot.docs
          .map((doc) => Student.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      return Right(students);
    } catch (e) {
      return Left(
        AppFailure(message: 'Failed to fetch students for section allotment'),
      );
    }
  }
  @override
  Future<Either<AppFailure, int>> assignSectionToStudents(
      String collegeId,
      String sectionId,
      String seatAllocationId,
      List<Student> students,
      ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final int studentsCount = students.length;

      final sectionRef = firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .doc(sectionId);

      final seatAllocationRef = firestore
          .collection('seat_allocation')
          .doc(collegeId)
          .collection('seat_allocation')
          .doc(seatAllocationId);

      await firestore.runTransaction((transaction) async {
        final sectionSnap = await transaction.get(sectionRef);
        if (!sectionSnap.exists) {
          throw Exception('Section not found');
        }

        final int sectionSeats =
            sectionSnap['availableSeats'] ?? 0;

        if (sectionSeats < studentsCount) {
          throw Exception('Not enough seats in section');
        }

        final seatAllocationSnap =
        await transaction.get(seatAllocationRef);
        if (!seatAllocationSnap.exists) {
          throw Exception('Seat allocation not found');
        }

        final int allocationSeats =
            seatAllocationSnap['availableSeats'] ?? 0;

        if (allocationSeats < studentsCount) {
          throw Exception('Seat allocation exceeded');
        }

        /// Assign section to students
        for (final student in students) {
          final studentRef = firestore
              .collection('students')
              .doc(collegeId)
              .collection('students')
              .doc(student.id);

          transaction.update(studentRef, {
            'sectionId': sectionId,
          });
        }

        /// Update seats
        transaction.update(sectionRef, {
          'availableSeats':
          FieldValue.increment(-studentsCount),
        });

        transaction.update(seatAllocationRef, {
          'availableSeats':
          FieldValue.increment(-studentsCount),
        });
      });

      return right(
        (await sectionRef.get())['availableSeats'],
      );
    } catch (e) {
      return left(
        AppFailure(message: e.toString()),
      );
    }
  }

}