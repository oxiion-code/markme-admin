import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_event.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_state.dart';

import '../repository/student_verification_repository.dart';

class StudentOnboardingBloc
    extends Bloc<StudentVerificationEvent, StudentOnboardingState> {
  final StudentVerificationRepository verificationRepository;
  final CourseRepository courseRepository;
  final BranchRepository branchRepository;
  final AcademicBatchRepository academicBatchRepository;
  final SectionRepository sectionRepository;

  StudentOnboardingBloc({
    required this.verificationRepository,
    required this.courseRepository,
    required this.branchRepository,
    required this.academicBatchRepository,
    required this.sectionRepository,
  }) : super(StudentVerificationInitial()) {
    on<LoadCoursesForStudentEvent>(_onLoadCourses);
    on<LoadBranchesForStudentEvent>(_onLoadBranches);
    on<LoadAcademicBatchesForStudentEvent>(_onLoadAcademicBatches);
    on<GetStudentsForVerificationEvent>(_onGetStudentsForVerification);
    on<MarkStudentVerifiedEvent>(_markStudentVerified);
    on<MarkStudentVerificationFailedEvent>(_markStudentVerificationFailed);
    on<LoadQualificationsForStudentVerification>(_onLoadQualifications);
    on<GetStudentsForSectionAllotmentEvent>(_onLoadStudentsForSectionAllotment);
    on<AssignSectionToStudentsEvent>(_onAssignSection);
    on<LoadSectionsForStudentEvent>(_onLoadSections);
  }

  // -------------------- LOAD COURSES --------------------
  Future<void> _onLoadCourses(
    LoadCoursesForStudentEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await courseRepository.getCourses(event.collegeId);
    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (courses) => emit(CoursesLoadedForStudentVerification(courses: courses)),
    );
  }

  // -------------------- LOAD BRANCHES --------------------
  Future<void> _onLoadBranches(
    LoadBranchesForStudentEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await branchRepository.loadAllBranchesForCourse(
      event.collegeId,
      event.courseId,
    );
    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (branches) =>
          emit(BranchesLoadedForStudentVerification(branches: branches)),
    );
  }

  // -------------------- LOAD BATCHES --------------------
  Future<void> _onLoadAcademicBatches(
    LoadAcademicBatchesForStudentEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await academicBatchRepository.getBatches(
      event.branchId,
      event.collegeId,
    );

    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (batches) => emit(BatchesLoadedForStudentVerification(batches: batches)),
    );
  }

  // -------------------- GET STUDENTS --------------------
  Future<void> _onGetStudentsForVerification(
    GetStudentsForVerificationEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await verificationRepository.getStudentsForVerification(
      event.collegeId,
      event.batchId,
    );

    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (students) => emit(LoadedStudentsForVerification(students: students)),
    );
  }

  // -------------------- MARK VERIFIED --------------------
  Future<void> _markStudentVerified(
    MarkStudentVerifiedEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await verificationRepository.markStudentVerified(
      event.collegeId,
      event.studentId,
    );

    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (_) => emit(MarkedStudentAsVerified()),
    );
  }

  Future<void> _markStudentVerificationFailed(
    MarkStudentVerificationFailedEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await verificationRepository.markStudentVerificationFail(
      event.collegeId,
      event.studentId,
      event.message,
    );
    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (_) => emit(MarkedStudentProfileVerificationFailed()),
    );
  }

  FutureOr<void> _onLoadQualifications(
    LoadQualificationsForStudentVerification event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());
    final result = await verificationRepository.loadStudentQualification(
      event.collegeId,
      event.studentId,
    );
    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (qualifications) => emit(
        LoadedQualificationsForStudentVerification(
          qualifications: qualifications,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadStudentsForSectionAllotment(
    GetStudentsForSectionAllotmentEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());

    final result = await verificationRepository.getStudentsForSectionAllotment(
      event.collegeId,
      event.batchId,
    );

    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (students) => emit(LoadedStudentsForSectionAllotment(students: students)),
    );
  }

  FutureOr<void> _onAssignSection(
    AssignSectionToStudentsEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());
    final result = await verificationRepository.assignSectionToStudents(
      event.collegeId,
      event.sectionId,
      event.allocationId,
      event.students,
    );
    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (seats) => emit(AssignedSectionToStudents(remainingSeats: seats)),
    );
  }

  FutureOr<void> _onLoadSections(
    LoadSectionsForStudentEvent event,
    Emitter<StudentOnboardingState> emit,
  ) async {
    emit(StudentVerificationLoading());
    final result = await sectionRepository.getAllSectionsForStudent(
      event.branchId,
      event.collegeId,
      event.batchId,
    );
    result.fold(
      (failure) => emit(StudentVerificationFailure(message: failure.message)),
      (sections) => emit(LoadedSectionsForStudent(sections: sections)),
    );
  }
}
