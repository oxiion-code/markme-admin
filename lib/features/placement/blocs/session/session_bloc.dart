import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/placement/blocs/session/session_state.dart';
import 'package:markme_admin/features/placement/blocs/session/sesssion_event.dart';

import '../../../../core/error/failure.dart';
import '../../repositories/session/placement_session_repository.dart';

class PlacementSessionBloc
    extends Bloc<PlacementSessionEvent, PlacementSessionState> {
  final PlacementSessionRepository repository;
  final BranchRepository branchRepository;
  final AcademicBatchRepository batchRepository;
  final CourseRepository courseRepository;
  PlacementSessionBloc({required this.repository, required this.courseRepository, required this.batchRepository, required this.branchRepository})
    : super(PlacementSessionInitial()) {
    on<AddPlacementSession>(_addSession);
    on<UpdatePlacementSession>(_updateSession);
    on<DeletePlacementSession>(_deleteSession);
  }

  /// ➕ ADD SESSION
  Future<void> _addSession(
    AddPlacementSession event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final Either<AppFailure, Unit> result = await repository.addSession(
      event.session,
    );

    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (_) => emit(PlacementSessionAdded()),
    );
  }

  /// ✏️ UPDATE SESSION
  Future<void> _updateSession(
    UpdatePlacementSession event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final Either<AppFailure, Unit> result = await repository.updateSession(
      event.session,
    );

    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (_) => emit(PlacementSessionUpdated()),
    );
  }

  /// ❌ DELETE SESSION
  Future<void> _deleteSession(
    DeletePlacementSession event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final Either<AppFailure, Unit> result = await repository.deleteSession(
      event.session,
    );

    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (_) => emit(PlacementSessionDeleted()),
    );
  }
}
