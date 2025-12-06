import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_state.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';

class AcademicBatchBloc extends Bloc<AcademicBatchEvent, AcademicBatchState> {
  final AcademicBatchRepository repository;
  final BranchRepository branchRepository;
  AcademicBatchBloc(this.repository, this.branchRepository)
    : super(AcademicBatchInitial()) {
    on<AddBatchEvent>(_addBatch);
    on<UpdateBatchEvent>(_updateBatch);
    on<DeleteBatchEvent>(_deleteBatch);
    on<LoadAllBatchesEvent>(_loadAllBatches);
    on<LoadAllBranchesEvent>(_loadAllBranches);
  }

  FutureOr<void> _addBatch(
    AddBatchEvent event,
    Emitter<AcademicBatchState> emit,
  ) async {
    emit(AcademicBatchLoading());
    final result = await repository.addBatch(event.batch);
    result.fold((failure) => emit(AcademicBatchError(failure.message)), (_) {
      emit(AcademicBatchSuccess());
      add(LoadAllBatchesEvent(branchId: event.batch.branchId));
    });
  }

  FutureOr<void> _updateBatch(
    UpdateBatchEvent event,
    Emitter<AcademicBatchState> emit,
  ) async {
    emit(AcademicBatchLoading());
    final result = await repository.updateBatch(event.batch);
    result.fold((failure) => emit(AcademicBatchError(failure.message)), (_) {
      emit(AcademicBatchSuccess());
      add(LoadAllBatchesEvent(branchId: event.batch.branchId));
    });
  }

  FutureOr<void> _deleteBatch(
    DeleteBatchEvent event,
    Emitter<AcademicBatchState> emit,
  ) async {
    emit(AcademicBatchLoading());
    final result = await repository.deleteBatch(event.batch);
    result.fold((failure) => emit(AcademicBatchError(failure.message)), (_) {
      emit(AcademicBatchSuccess());
      add(LoadAllBatchesEvent(branchId: event.batch.branchId));
    });
  }

  FutureOr<void> _loadAllBatches(
    LoadAllBatchesEvent event,
    Emitter<AcademicBatchState> emit,
  ) async {
    emit(AcademicBatchLoading());
    final result = await repository.getBatches(event.branchId);
    result.fold((failure) => emit(AcademicBatchError(failure.message)), (
      batches,
    ) {
      emit(AcademicBatchesLoaded(batches));
    });
  }

  FutureOr<void> _loadAllBranches(
    LoadAllBranchesEvent event,
    Emitter<AcademicBatchState> emit,
  ) async {
    emit(AcademicBatchLoading());
    final result = await branchRepository.loadAllBranches();
    result.fold((failure) => emit(AcademicBatchError(failure.message)), (
      branches,
    ) {
      emit(BranchesLoaded(branches));
      add(
        LoadAllBatchesEvent(
          branchId: branches.isNotEmpty ? branches.first.branchId : "cse",
        ),
      );
    });
  }
}
