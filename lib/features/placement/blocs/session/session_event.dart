import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/placement/models/session/application_args.dart';
import '../../models/session/placement_session.dart';

abstract class PlacementSessionEvent extends Equatable {
  const PlacementSessionEvent();

  @override
  List<Object?> get props => [];
}

/// ➕ Add Session
class AddPlacementSession extends PlacementSessionEvent {
  final PlacementSession session;

  const AddPlacementSession(this.session);

  @override
  List<Object?> get props => [session];
}

/// ✏️ Update Session
class UpdatePlacementSession extends PlacementSessionEvent {
  final PlacementSession session;

  const UpdatePlacementSession(this.session);

  @override
  List<Object?> get props => [session];
}
class DeletePlacementSession extends PlacementSessionEvent {
  final PlacementSession session;

  const DeletePlacementSession(this.session);

  @override
  List<Object?> get props => [session];
}
class LoadCoursesForPlacementSession extends PlacementSessionEvent{
  final String collegeId;
  const LoadCoursesForPlacementSession({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}

class LoadBranchesForPlacementSession extends PlacementSessionEvent{
  final String collegeId;
  final String courseId;
  const LoadBranchesForPlacementSession({required this.courseId, required this.collegeId});
  @override
  List<Object?> get props => [collegeId, courseId];
}
class LoadSessionData extends PlacementSessionEvent{
  final String collegeId;
  final String sessionId;
  const LoadSessionData({required this.collegeId, required this.sessionId});
  @override
  List<Object?> get props => [collegeId,sessionId];
}

class LoadBatchesForPlacementSession extends PlacementSessionEvent{
  final String collegeId;
  final String branchId;
  const LoadBatchesForPlacementSession({required this.branchId, required this.collegeId});
  @override
  List<Object?> get props => [collegeId, branchId];
}
class LoadPlacementSessionsEvent extends PlacementSessionEvent{
  final String collegeId;
  const LoadPlacementSessionsEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
class LoadSessionApplicationsEvent extends PlacementSessionEvent{
  final String collegeId;
  final String sessionId;
  const LoadSessionApplicationsEvent({required this.collegeId, required this.sessionId});
  @override
  // TODO: implement props
  List<Object?> get props => [collegeId,sessionId];
}
class MarkSessionAttendanceEvent extends PlacementSessionEvent{
   final String collegeId;
   final String sessionId;
   final Map<String,bool> attendances;
   const MarkSessionAttendanceEvent({required this.sessionId, required this.collegeId, required this.attendances});
   @override
  List<Object?> get props => [collegeId,sessionId];
}
class DeleteSessionAttendanceEvent extends PlacementSessionEvent{
  final String collegeId;
  final String sessionId;
  const DeleteSessionAttendanceEvent({required this.sessionId, required this.collegeId});
  @override
  List<Object?> get props => [collegeId, sessionId];
}
class GetSessionAttendanceEvent extends PlacementSessionEvent{
  final String collegeId;
  final String sessionId;
  const GetSessionAttendanceEvent({required this.collegeId, required this.sessionId});
  @override
  List<Object?> get props => [collegeId, sessionId];
}
