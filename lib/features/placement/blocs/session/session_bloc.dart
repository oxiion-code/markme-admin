import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/placement/blocs/session/session_state.dart';
import 'package:markme_admin/features/placement/blocs/session/session_event.dart';

import '../../../../core/error/failure.dart';
import '../../repositories/session/placement_session_repository.dart';

class PlacementSessionBloc
    extends Bloc<PlacementSessionEvent, PlacementSessionState> {
  final PlacementSessionRepository repository;
  final BranchRepository branchRepository;
  final AcademicBatchRepository batchRepository;
  final CourseRepository courseRepository;
  PlacementSessionBloc({
    required this.repository,
    required this.courseRepository,
    required this.batchRepository,
    required this.branchRepository,
  }) : super(PlacementSessionInitial()) {
    on<AddPlacementSession>(_addSession);
    on<UpdatePlacementSession>(_updateSession);
    on<DeletePlacementSession>(_deleteSession);
    on<LoadCoursesForPlacementSession>(_loadCourses);
    on<LoadBranchesForPlacementSession>(_loadBranches);
    on<LoadBatchesForPlacementSession>(_loadBatches);
    on<LoadSessionData>(_loadSessionData);
    on<LoadPlacementSessionsEvent>(_loadPlacementSessions);
    on<LoadSessionApplicationsEvent>(_onLoadSessionApplications);
    on<MarkSessionAttendanceEvent>(_onMarkSessionAttendance);
    on<DeleteSessionAttendanceEvent>(_onDeleteSessionAttendance);
    on<GetSessionAttendanceEvent>(_onGetSessionAttendance);
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

  FutureOr<void> _loadCourses(
    LoadCoursesForPlacementSession event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final result = await courseRepository.getCourses(event.collegeId);

    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (courses) => emit(CoursesLoadedForSession(loadedCourses: courses)),
    );
  }

  FutureOr<void> _loadBranches(
    LoadBranchesForPlacementSession event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final result = await branchRepository.loadAllBranchesForCourse(
      event.collegeId,
      event.courseId,
    );
    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (branches) => emit(BranchesLoadedForSession(loadedBranches: branches)),
    );
  }

  FutureOr<void> _loadBatches(
    LoadBatchesForPlacementSession event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final result = await batchRepository.getBatches(
      event.branchId,
      event.collegeId,
    );

    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (batches) => emit(
        BatchesLoadedForSession(
          loadedBatches: batches,
          branchId: event.branchId,
        ),
      ),
    );
  }

  FutureOr<void> _loadSessionData(
    LoadSessionData event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());

    final result = await repository.loadPlacementSession(
      event.collegeId,
      event.sessionId,
    );
    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (session) => emit(LoadedSessionData(session: session)),
    );
  }

  FutureOr<void> _loadPlacementSessions(
    LoadPlacementSessionsEvent event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());
    final result = await repository.loadLivePlacementSessions(event.collegeId);
    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (placementSessions) =>
          emit(AllPlacementSessionLoaded(placementSessions: placementSessions)),
    );
  }

  FutureOr<void> _onLoadSessionApplications(
    LoadSessionApplicationsEvent event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());
    final result = await repository.loadSessionApplications(
      event.collegeId,
      event.sessionId,
    );
    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (forms) => emit(ApplicationsLoadedForSession(placementForms: forms)),
    );
  }

  FutureOr<void> _onMarkSessionAttendance(
    MarkSessionAttendanceEvent event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());
    final result = await repository.markAttendanceForSession(
      event.collegeId,
      event.sessionId,
      event.attendances,
    );
    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (_) => emit(AttendanceMarkedForSession()),
    );
  }

  FutureOr<void> _onDeleteSessionAttendance(
    DeleteSessionAttendanceEvent event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());
    final result = await repository.deleteAttendanceForSession(
      event.collegeId,
      event.sessionId,
    );
    result.fold(
      (failure) => emit(PlacementSessionFailure(failure.message)),
      (_) => emit(AttendanceDeletedForSession()),
    );
  }

  FutureOr<void> _onGetSessionAttendance(
    GetSessionAttendanceEvent event,
    Emitter<PlacementSessionState> emit,
  ) async {
    emit(PlacementSessionLoading());
    final result = await repository.getAttendancesForSession(
      event.collegeId,
      event.sessionId,
    );
    result.fold(
          (failure) => emit(PlacementSessionFailure(failure.message)),
          (attendance) => emit(LoadedAttendanceForSession(sessionAttendanceModel: attendance)),
    );
  }
}
