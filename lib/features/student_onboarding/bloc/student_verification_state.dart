import 'package:equatable/equatable.dart';
import 'package:markme_admin/data/models/student.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';

import '../models/qualification.dart';


abstract class StudentOnboardingState extends Equatable{

}

class StudentVerificationInitial extends StudentOnboardingState{
  @override
  List<Object?> get props => [];
}
class StudentVerificationLoading extends StudentOnboardingState{
  @override
  List<Object?> get props => [];
}
class CoursesLoadedForStudentVerification extends StudentOnboardingState{
  final List<Course> courses;
  CoursesLoadedForStudentVerification({required this.courses});
  @override
  List<Object?> get props => [courses];
}
class BranchesLoadedForStudentVerification extends StudentOnboardingState{
  final List<Branch> branches;
  BranchesLoadedForStudentVerification({required this.branches});
  @override
  List<Object?> get props => [branches];
}
class BatchesLoadedForStudentVerification extends StudentOnboardingState{
  final List<AcademicBatch> batches;
  BatchesLoadedForStudentVerification({required this.batches});
  @override
  List<Object?> get props => [batches];
}
class  MarkedStudentAsVerified extends StudentOnboardingState{
  @override
  List<Object?> get props => [];
}
class LoadedStudentsForVerification extends StudentOnboardingState{
  final List<Student> students;
  LoadedStudentsForVerification({required this.students});
  @override
  List<Object?> get props => [students];
}
class LoadedStudentsForSectionAllotment extends StudentOnboardingState{
  final List<Student> students;
  LoadedStudentsForSectionAllotment({required this.students});
  @override
  List<Object?> get props => [students];
}
class MarkedStudentProfileVerificationFailed extends StudentOnboardingState{
  @override
  List<Object?> get props => [];
}
class LoadedQualificationsForStudentVerification extends StudentOnboardingState{
  final List<Qualification> qualifications;
  LoadedQualificationsForStudentVerification({required this.qualifications});
  @override
  List<Object?> get props => [qualifications];
}

class AssignedSectionToStudents extends StudentOnboardingState{
  final int remainingSeats;
  AssignedSectionToStudents({required this.remainingSeats});
  @override
  List<Object?> get props => [remainingSeats];
}

class LoadedSectionsForStudent extends StudentOnboardingState{
  final List<Section> sections;
  LoadedSectionsForStudent({required this.sections});
  @override
  List<Object?> get props => [sections];
}
class StudentVerificationFailure extends StudentOnboardingState{
  final String message;
  StudentVerificationFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
