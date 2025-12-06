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
  }

  Future<void> _onAddBranch(
      AddNewBranchEvent event,
      Emitter<BranchState> emit,
      ) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.addNewBranch(event.branch);
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (_) => emit(BranchSuccess()),
    );
  }


  Future<void> _onUpdateBranch(
      UpdateBranchEvent event,
      Emitter<BranchState> emit,
      ) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.updateBranch(event.branch);
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (_) => emit(BranchSuccess()),
    );
  }


  Future<void> _onDeleteBranch(
      DeleteBranchEvent event,
      Emitter<BranchState> emit,
      ) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.deleteBranch(event.branch);
    result.fold(
          (failure) => emit(BranchFailureState(failure.message)),
          (_) => emit(BranchSuccess()),
    );
  }


  Future<void> _onLoadBranches(
    LoadBranchesEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchDataLoadingState());
    final result = await branchRepository.loadAllBranches();
    result.fold(
      (failure) => emit(BranchFailureState(failure.message)),
      (branches) => emit(BranchesLoaded(branches)),
    );
  }


  Future<void> _onLoadCourses(
    LoadCourseForBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchDataLoadingState());
    final result = await courseRepository.getCourses();
    result.fold(
      (failure) => emit(BranchFailureState(failure.message)),
      (courses) => emit(LoadedCoursesForBranchState(courses)),
    );
  }
}











