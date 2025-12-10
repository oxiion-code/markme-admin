import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_state.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/semester_repo/semester_repository.dart';

class SemesterBloc extends Bloc<SemesterEvent, SemesterState> {
  final CourseRepository courseRepository;
  final SemesterRepository semesterRepository;

  SemesterBloc(this.courseRepository, this.semesterRepository)
      : super(SemesterInitial()) {
    on<AddNewSemesterEvent>(_addNewSemester);
    on<DeleteSemesterEvent>(_deleteSemester);
    on<UpdateSemesterEvent>(_updateSemester);
    on<LoadCoursesEvent>(_loadCourses);
    on<LoadSemestersEvent>(_loadSemesters);
  }

  FutureOr<void> _addNewSemester(AddNewSemesterEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.addSemester(event.semester,event.collegeId);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (_) {
      emit(SemesterSuccess());
      add(LoadSemestersEvent(courseId: event.semester.courseId,collegeId: event.collegeId));
    });
  }

  FutureOr<void> _deleteSemester(DeleteSemesterEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.deleteSemester(event.semester,event.collegeId);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (_) {
      emit(SemesterSuccess());
      add(LoadSemestersEvent(courseId: event.semester.courseId, collegeId: event.collegeId));
    });
  }

  FutureOr<void> _updateSemester(UpdateSemesterEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.updateSemester(event.semester,event.collegeId);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (_) {
      emit(SemesterSuccess());
      add(LoadSemestersEvent(courseId: event.semester.courseId,collegeId: event.collegeId));
    });
  }

  FutureOr<void> _loadCourses(LoadCoursesEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await courseRepository.getCourses(event.collegeId);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (
        courses) {
      emit(CoursesLoaded(courses));
    });
  }

  FutureOr<void> _loadSemesters(LoadSemestersEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.getSemesters(event.courseId,event.collegeId);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (
        semesters) {
      emit(SemestersLoaded(semesters));
    });
  }
}