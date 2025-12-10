import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_event.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_state.dart';
import 'package:markme_admin/features/teacher/repository/teacher_repository.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherRepository teacherRepository;
  final BranchRepository branchRepository;
  TeacherBloc(this.teacherRepository, this.branchRepository)
    : super(TeacherInitial()) {
    on<AddTeacherEvent>(_addTeacher);
    on<UpdateTeacherEvent>(_updateTeacher);
    on<DeleteTeacherEvent>(_deleteTeacher);
    on<LoadTeachersEvent>(_getTeachers);
    on<LoadBranchesForTeacherEvent>(_getBranches);
  }

  FutureOr<void> _addTeacher(
    AddTeacherEvent event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    final result = await teacherRepository.addTeacher(event.teacher,event.collegeId);
    result.fold((failure) => emit(TeacherError(failure.message)), (_) {
      emit(TeacherSuccess());
      add(LoadTeachersEvent(collegeId: event.collegeId));
    });
  }

  FutureOr<void> _updateTeacher(
    UpdateTeacherEvent event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    final result = await teacherRepository.updateTeacher(event.teacher,event.collegeId);
    result.fold((failure) => emit(TeacherError(failure.message)), (_) {
      emit(TeacherSuccess());
      add(LoadTeachersEvent(collegeId: event.collegeId));
    });
  }

  FutureOr<void> _deleteTeacher(
    DeleteTeacherEvent event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    final result = await teacherRepository.deleteTeacher(event.teacher, event.collegeId);
    result.fold(
          (failure) => emit(TeacherError(failure.message)),
          (_){
        emit(TeacherSuccess());
        add(LoadTeachersEvent(collegeId: event.collegeId));
      },
    );
  }

  FutureOr<void> _getTeachers(
    LoadTeachersEvent event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    final result = await teacherRepository.getTeachers(event.collegeId);
    result.fold(
          (failure) => emit(TeacherError(failure.message)),
          (teachers){
        emit(TeachersLoaded(teachers));
      },
    );
  }

  FutureOr<void> _getBranches(
    LoadBranchesForTeacherEvent event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    final result = await branchRepository.loadAllBranches(event.collegeId);
    result.fold(
          (failure) => emit(TeacherError(failure.message)),
          (branches){
        emit(LoadBranchesForTeacher(branches));
        add(LoadTeachersEvent(collegeId: event.collegeId));
      },
    );
  }
}
