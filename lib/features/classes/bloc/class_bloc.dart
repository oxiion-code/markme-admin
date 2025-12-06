import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/class_repository.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository classRepository;
  ClassBloc(this.classRepository) : super(ClassInitial()) {
    on<AddClassEvent>(_addClass);
    on<UpdateClassEvent>(_updateClass);
    on<DeleteClassEvent>(_deleteClass);
    on<GetAllClassesEvent>(_getAllClasses);
    on<GetAllClassesForTeacherEvent>(_getAllClassesForTeacher);
    on<GetAllCoursesForClassEvent>(_getAllCourses);
    on<GetBranchesForCourseInClassEvent>(_getBranchesForCourse);
    on<GetBatchesForBranchInClassEvent>(_getBatchesForBranch);
  }

  FutureOr<void> _addClass(AddClassEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.addClass(event.classInfo);
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (_) => emit(ClassSuccess()),
    );
  }

  FutureOr<void> _updateClass(UpdateClassEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.updateClass(event.classInfo);
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (_) => emit(ClassSuccess()),
    );
  }

  FutureOr<void> _deleteClass(DeleteClassEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.deleteClass(event.classId);
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (_) => emit(ClassSuccess()),
    );
  }

  FutureOr<void> _getAllClasses(GetAllClassesEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.getAllClasses();
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (classes) => emit(ClassesLoaded(classes)),
    );
  }

  FutureOr<void> _getAllClassesForTeacher(GetAllClassesForTeacherEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.getClassesForTeacher(event.teacherId);
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (classes) => emit(ClassesLoadedForTeacher(classes)),
    );
  }

  FutureOr<void> _getAllCourses(GetAllCoursesForClassEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.getAllCourses();
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (courses) => emit(CoursesLoadedForClass(courses)),
    );
  }

  FutureOr<void> _getBranchesForCourse(GetBranchesForCourseInClassEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.getBranchesForCourse(event.courseId);
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (branches) => emit(BranchesLoadedForClass(branches)),
    );
  }

  FutureOr<void> _getBatchesForBranch(GetBatchesForBranchInClassEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    final result = await classRepository.getBatchesForBranch(event.branchId);
    result.fold(
          (failure) => emit(ClassFailure(failure.message)),
          (batches) => emit(BatchesLoadedForClass(batches)),
    );
  }
}
