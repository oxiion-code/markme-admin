import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/placement/models/session/placement_form.dart';
import 'package:markme_admin/features/placement/models/session/placement_session.dart';
import 'package:markme_admin/features/placement/models/session/session_attendance.dart';


abstract class PlacementSessionState extends Equatable {
  const PlacementSessionState();

  @override
  List<Object?> get props => [];
}

class PlacementSessionInitial extends PlacementSessionState {}

class PlacementSessionLoading extends PlacementSessionState {}


class PlacementSessionAdded extends PlacementSessionState {}


class PlacementSessionUpdated extends PlacementSessionState {}

class CoursesLoadedForSession extends PlacementSessionState{
  final List<Course> loadedCourses;
  const CoursesLoadedForSession({required this.loadedCourses});
  @override
  List<Object?> get props => [loadedCourses];
}

class BranchesLoadedForSession extends PlacementSessionState{
  final List<Branch> loadedBranches;
  const BranchesLoadedForSession({required this.loadedBranches});
  @override
  List<Object?> get props => [loadedBranches];
}
class BatchesLoadedForSession extends PlacementSessionState{
  final List<AcademicBatch> loadedBatches;
  final String branchId;
  const BatchesLoadedForSession({required this.loadedBatches, required this.branchId});
  @override
  List<Object?> get props => [loadedBatches];
}
 class LoadedSessionData extends PlacementSessionState{
  final PlacementSession session;
  const LoadedSessionData({required this.session});
  @override
  List<Object?> get props => [session];
 }

class PlacementSessionDeleted extends PlacementSessionState {}

class AllPlacementSessionLoaded extends PlacementSessionState{
  final List<PlacementSession> placementSessions;
  const AllPlacementSessionLoaded({required this.placementSessions});
  @override
  List<Object?> get props => [placementSessions];
}
class ApplicationsLoadedForSession extends PlacementSessionState{
  final List<PlacementForm> placementForms;
  const ApplicationsLoadedForSession({required this.placementForms});
  @override
  List<Object?> get props => [placementForms];
}

class PlacementSessionFailure extends PlacementSessionState {
  final String message;

  const PlacementSessionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
class AttendanceMarkedForSession extends PlacementSessionState{
}
class AttendanceDeletedForSession extends PlacementSessionState{
}
class LoadedAttendanceForSession extends PlacementSessionState{
final SessionAttendanceModel? sessionAttendanceModel;
const LoadedAttendanceForSession({required this.sessionAttendanceModel});
}
