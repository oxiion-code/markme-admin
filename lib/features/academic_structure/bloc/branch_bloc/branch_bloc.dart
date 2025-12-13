import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_state.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository branchRepository;
  final CourseRepository courseRepository;

  BranchBloc(this.branchRepository, this.courseRepository)
      : super(BranchInitialState()) {
    on<AddNewBranchEvent>(_onAddBranch);
    on<UpdateBranchEvent>(_onUpdateBranch);
    on<DeleteBranchEvent>(_onDeleteBranch);
    on<LoadBranchesEvent>(_onLoadBranches);
    on<LoadCourseForBranchEvent>(_onLoadCourses);
    on<LoadBranchSeatAllocationsEvent>(_loadBranchSeatAllocation);
    on<AddBranchSeatAllocationEvent>(_addBranchSeatAllocation);
    on<UpdateBranchSeatAllocationEvent>(_updateBranchSeatAllocation);
    on<DeleteBranchSeatAllocationEvent>(_deleteBranchSeatAllocation);
  }

  Future<void> _onAddBranch(AddNewBranchEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.addNewBranch(
      event.branch,
      event.collegeId,
    );
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (_) => emit(BranchSuccess()),
    );
  }

  Future<void> _onUpdateBranch(UpdateBranchEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.updateBranch(
      event.branch,
      event.collegeId,
    );
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (_) => emit(BranchSuccess()),
    );
  }

  Future<void> _onDeleteBranch(DeleteBranchEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.deleteBranch(
      event.branch,
      event.collegeId,
    );
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (_) => emit(BranchSuccess()),
    );
  }

  Future<void> _onLoadBranches(LoadBranchesEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.loadAllBranches(event.collegeId);
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (branches) => emit(BranchesLoaded(branches)),
    );
  }

  Future<void> _onLoadCourses(LoadCourseForBranchEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchDataLoadingState());
    final result = await courseRepository.getCourses(event.collegeId);
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (courses) => emit(LoadedCoursesForBranchState(courses)),
    );
  }

  FutureOr<void> _loadBranchSeatAllocation(LoadBranchSeatAllocationsEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchSeatAllocationLoading()); // optional

    final result = await branchRepository.loadBranchSeatAllocations(
      event.collegeId,
      event.branchId,
    );

    result.fold(
          (failure) =>
          emit(BranchSeatAllocationError(message: failure.message)),
          (seatAllocations) =>
          emit(BranchSeatAllocationsLoaded(seatAllocations: seatAllocations)),
    );
  }

  FutureOr<void> _addBranchSeatAllocation(AddBranchSeatAllocationEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchSeatAllocationLoading()); // optional

    final result = await branchRepository.addBranchSeats(
      event.seatAllocation,
      event.collegeId,
    );

    result.fold(
          (failure) =>
          emit(BranchSeatAllocationError(message: failure.message)),
          (_) => emit(BranchSeatAllocationAdded()),
    );
  }

  FutureOr<void> _updateBranchSeatAllocation(
      UpdateBranchSeatAllocationEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchSeatAllocationLoading()); // optional

    final result = await branchRepository.updateSeatAllocation(
      event.seatAllocation,
      event.collegeId,
    );

    result.fold(
          (failure) =>
          emit(BranchSeatAllocationError(message: failure.message)),
          (_) => emit(BranchSeatAllocationUpdated()),
    );
  }

  FutureOr<void> _deleteBranchSeatAllocation(
      DeleteBranchSeatAllocationEvent event,
      Emitter<BranchState> emit,) async {
    emit(BranchSeatAllocationLoading()); // optional

    final result = await branchRepository.deleteSeatAllocation(
      event.seatAllocation,
      event.collegeId,
    );

    result.fold(
          (failure) =>
          emit(BranchSeatAllocationError(message: failure.message)),
          (_) => emit(BranchSeatAllocationDeleted()),
    );
  }
}