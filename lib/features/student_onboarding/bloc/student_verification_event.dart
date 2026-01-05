import 'package:equatable/equatable.dart';
import 'package:markme_admin/data/models/student.dart';

abstract class StudentVerificationEvent extends Equatable {}

class GetStudentsForVerificationEvent extends StudentVerificationEvent {
  final String collegeId;
  final String courseId;
  final String branchId;
  final String batchId;
  GetStudentsForVerificationEvent({
    required this.collegeId,
    required this.courseId,
    required this.branchId,
    required this.batchId,
  });
  @override
  List<Object?> get props => [collegeId, courseId, branchId, batchId];
}
class LoadSectionsForStudentEvent extends StudentVerificationEvent{
  final String collegeId;
  final String branchId;
  final String batchId;
  LoadSectionsForStudentEvent({required this.collegeId, required this.branchId, required this.batchId});
  @override
  List<Object?> get props => [collegeId, branchId, batchId];
}

class AssignSectionToStudentsEvent extends StudentVerificationEvent{
  final String collegeId;
  final String allocationId;
  final String sectionId;
  final List<Student> students;
  AssignSectionToStudentsEvent({required this.collegeId, required this.allocationId, required this.students, required this.sectionId});
  @override
  List<Object?> get props => [collegeId,allocationId,sectionId,students];
}

class GetStudentsForSectionAllotmentEvent extends StudentVerificationEvent {
  final String collegeId;
  final String courseId;
  final String batchId;
  GetStudentsForSectionAllotmentEvent({
    required this.collegeId,
    required this.courseId,
    required this.batchId,
  });
  @override
  List<Object?> get props => [courseId, collegeId, batchId];
}

class LoadCoursesForStudentEvent extends StudentVerificationEvent {
  final String collegeId;
  LoadCoursesForStudentEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}

class LoadBranchesForStudentEvent extends StudentVerificationEvent {
  final String collegeId;
  final String courseId;
  LoadBranchesForStudentEvent({
    required this.courseId,
    required this.collegeId,
  });
  @override
  List<Object?> get props => [collegeId, courseId];
}

class LoadAcademicBatchesForStudentEvent extends StudentVerificationEvent {
  final String branchId;
  final String collegeId;
  LoadAcademicBatchesForStudentEvent({
    required this.branchId,
    required this.collegeId,
  });
  @override
  List<Object?> get props => [branchId, collegeId];
}

class MarkStudentVerifiedEvent extends StudentVerificationEvent {
  final String collegeId;
  final String studentId;
  MarkStudentVerifiedEvent({required this.collegeId, required this.studentId});
  @override
  List<Object?> get props => [collegeId, studentId];
}

class MarkStudentVerificationFailedEvent extends StudentVerificationEvent {
  final String collegeId;
  final String message;
  final String studentId;
  MarkStudentVerificationFailedEvent({
    required this.collegeId,
    required this.message,
    required this.studentId,
  });
  @override
  List<Object?> get props => [collegeId, studentId, message];
}

class LoadQualificationsForStudentVerification
    extends StudentVerificationEvent {
  final String collegeId;
  final String studentId;
  LoadQualificationsForStudentVerification({
    required this.studentId,
    required this.collegeId,
  });
  @override
  List<Object?> get props => [collegeId, studentId];
}
