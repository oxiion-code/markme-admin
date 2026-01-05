import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/data/models/student.dart';
import 'package:markme_admin/features/student_onboarding/models/qualification.dart';

abstract class StudentVerificationRepository {
  Future<Either<AppFailure, Unit>> markStudentVerified(String collegeId, String studentId);
  Future<Either<AppFailure,List<Student>>> getStudentsForVerification(String collegeId,String batchId);
  Future<Either<AppFailure, Unit>> markStudentVerificationFail(String collegeId, String studentI,String message);
  Future<Either<AppFailure,List<Qualification>>> loadStudentQualification(String collegeId,String studentId);
  Future<Either<AppFailure,List<Student>>> getStudentsForSectionAllotment(String collegeId, String batchId);
  Future<Either<AppFailure,int>> assignSectionToStudents(String collegeId,String sectionId,String seatAllocationId,List<Student> students);

}

