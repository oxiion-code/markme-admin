import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/subjects/bloc/subject_event.dart';
import 'package:markme_admin/features/subjects/bloc/subject_state.dart';
import 'package:markme_admin/features/subjects/repository/subject_repository.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository subjectRepository;
  final BranchRepository branchRepository;
  final AcademicBatchRepository batchRepository;
  SubjectBloc(this.subjectRepository,this.branchRepository,this.batchRepository) : super(SubjectInitial()) {
    on<AddSubjectEvent>(_addSubject);
    on<UpdateSubjectEvent>(_updateSubject);
    on<DeleteSubjectEvent>(_deleteSubject);
    on<GetAllSubjects>(_getAllSubjects);
    on<LoadAllBatches>(_getAllBatches);
    on<LoadAllBranches>(_getAllBranches);
  }

  FutureOr<void> _addSubject(
    AddSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.addSubject(event.subject, event.collegeId);
    result.fold(
      (failure) => emit(SubjectError(failure.message)),
      (_) {
        emit(SubjectSuccess(branchId: event.subject.branchId,operation: "add"));
        add(GetAllSubjects(collegeId: event.collegeId,branchId: event.subject.branchId));
      },
    );
  }

  FutureOr<void> _updateSubject(
    UpdateSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.updateSubject(event.subject,event.collegeId);
    result.fold(
      (failure) => emit(SubjectError(failure.message)),
      (_){
        emit(SubjectSuccess(branchId: event.subject.branchId,operation: "update"));
        add(GetAllSubjects(collegeId: event.collegeId,branchId: event.subject.branchId));
      },
    );
  }

  FutureOr<void> _deleteSubject(
    DeleteSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.deleteSubject(event.subject,event.collegeId);
    result.fold(
      (failure) => emit(SubjectError(failure.message)),
      (_){
        emit(SubjectSuccess(branchId: event.subject.branchId,operation: "delete"));
        add(GetAllSubjects(collegeId: event.collegeId,branchId: event.subject.branchId));
      } ,
    );
  }
  FutureOr<void> _getAllSubjects(
    GetAllSubjects event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.getSubjects(event.collegeId,event.branchId);
    result.fold(
      (failure) => emit(SubjectError(failure.message)),
      (subjects){
        emit(SubjectLoaded(subjects));
      },
    );
  }

  FutureOr<void> _getAllBatches(LoadAllBatches event, Emitter<SubjectState> emit) async {
    emit(SubjectLoading());
    final result = await batchRepository.getBatches(event.branchId,event.collegeId);
    result.fold(
          (failure) => emit(SubjectError(failure.message)),
          (batches) => emit(BatchesLoaded(batches)),
    );
  }

  FutureOr<void> _getAllBranches(LoadAllBranches event, Emitter<SubjectState> emit) async {
    emit(SubjectLoading());
    final result = await branchRepository.loadAllBranches(event.collegeId);
    result.fold(
          (failure) => emit(SubjectError(failure.message)),
          (branches) => emit(BranchesLoaded(branches)),
    );
  }
}
