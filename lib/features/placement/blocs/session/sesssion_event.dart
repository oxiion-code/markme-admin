import 'package:equatable/equatable.dart';
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
class LoadBatchesForPlacementSession extends PlacementSessionEvent{
  final String collegeId;
  final String branchId;
  const LoadBatchesForPlacementSession({required this.branchId, required this.collegeId});
  @override
  List<Object?> get props => [collegeId, branchId];
}
