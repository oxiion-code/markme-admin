import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_state.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository.dart';
import 'package:markme_admin/features/teacher/repository/teacher_repository.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final SectionRepository sectionRepository;
  final CourseRepository courseRepository;
  final AcademicBatchRepository batchRepository;
  final BranchRepository branchRepository;
  final TeacherRepository teacherRepository;
  SectionBloc(
    this.branchRepository,
    this.sectionRepository,
    this.batchRepository,
    this.teacherRepository,
    this.courseRepository,
  ) : super(SectionInitial()) {
    on<AddNewSectionEvent>(_addSection);
    on<UpdateSectionEvent>(_updateSection);
    on<DeleteSectionEvent>(_deleteSection);
    on<LoadAllBatchesEvent>(_loadBatches);
    on<LoadAllSectionEvent>(_loadSections);
    on<LoadAllBranchesEvent>(_loadSemesters);
    on<LoadTeachersForSection>(_loadTeachers);
    on<LoadCoursesForSection>(_onLoadCourses);
    on<LoadSectionsForBatchEvent>(_onLoadSectionsForBatch);
    on<PromoteSectionEvent>(_onPromoteSection);
  }

  FutureOr<void> _addSection(
    AddNewSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.addSection(
      event.section,
      event.collegeId,
    );
    result.fold((failure) => emit(SectionError(failure.message)), (_) {
      emit(SectionSuccess());
      add(
        LoadAllSectionEvent(
          branchId: event.section.branchId,
          collegeId: event.collegeId,
        ),
      );
    });
  }

  FutureOr<void> _updateSection(
    UpdateSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.updateSection(
      event.section,
      event.collegeId,
    );
    result.fold((failure) => emit(SectionError(failure.message)), (_) {
      emit(SectionSuccess());
      add(
        LoadAllSectionEvent(
          branchId: event.section.branchId,
          collegeId: event.collegeId,
        ),
      );
    });
  }

  FutureOr<void> _deleteSection(
    DeleteSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.deleteSection(
      event.section,
      event.collegeId,
    );
    result.fold((failure) => emit(SectionError(failure.message)), (_) {
      emit(SectionSuccess());
      add(
        LoadAllSectionEvent(
          branchId: event.section.branchId,
          collegeId: event.collegeId,
        ),
      );
    });
  }

  FutureOr<void> _loadBatches(
    LoadAllBatchesEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await batchRepository.getBatches(
      event.branchId,
      event.collegeId,
    );
    result.fold((failure) => emit(SectionError(failure.message)), (batches) {
      emit(BatchesLoaded(batches));
    });
  }

  FutureOr<void> _loadSections(
    LoadAllSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.getAllSections(
      event.branchId,
      event.collegeId,
    );
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (sections) => emit(SectionsLoaded(sections)),
    );
  }

  FutureOr<void> _loadSemesters(
    LoadAllBranchesEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await branchRepository.loadAllBranches(event.collegeId);
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (branches) => emit(BranchesLoaded(branches)),
    );
  }

  FutureOr<void> _loadTeachers(
    LoadTeachersForSection event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await teacherRepository.getTeachersForBranch(
      event.branchId,
      event.collegeId,
    );
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (teachers) => emit(TeachersLoadedForSection(teachers)),
    );
  }

  FutureOr<void> _onLoadCourses(
    LoadCoursesForSection event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await courseRepository.getCourses(event.collegeId);
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (courses) => emit(CoursesLoaded(courses: courses)),
    );
  }

  FutureOr<void> _onLoadSectionsForBatch(
    LoadSectionsForBatchEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.getAllSectionsForStudent(
      event.branchId,
      event.collegeId,
      event.batchId,
    );
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (sections) => emit(SectionsLoaded(sections)),
    );
  }

  FutureOr<void> _onPromoteSection(
    PromoteSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(PromoteSectionLoading());
    final result = await sectionRepository.promoteSection(
      event.collegeId,
      event.sectionId,
      event.currentSemId,
      event.currentSemNo,
    );
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (_) => emit(SectionPromoted()),
    );
  }
}
