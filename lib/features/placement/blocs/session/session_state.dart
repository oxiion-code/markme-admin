import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';


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
  const BatchesLoadedForSession({required this.loadedBatches});
  @override
  List<Object?> get props => [loadedBatches];
}


class PlacementSessionDeleted extends PlacementSessionState {}


class PlacementSessionFailure extends PlacementSessionState {
  final String message;

  const PlacementSessionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
