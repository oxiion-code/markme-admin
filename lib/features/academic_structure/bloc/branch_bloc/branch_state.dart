import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch_seat_allocation.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';

import '../../models/branch.dart';

class BranchState extends Equatable {
  const BranchState();
  @override
  List<Object?> get props => [];
}

class BranchInitialState extends BranchState {}

class BranchDataLoadingState extends BranchState {}

class BranchSuccess extends BranchState {}

class BranchSeatAllocationLoading extends BranchState{}

class BranchSeatAllocationAdded extends BranchState{

}
class BranchSeatAllocationDeleted extends BranchState{

}
class BranchSeatAllocationUpdated extends BranchState{

}
class BranchSeatAllocationsLoaded extends BranchState{
  final List<BranchSeatAllocation> seatAllocations;
  const BranchSeatAllocationsLoaded({required this.seatAllocations});
  @override
  List<Object?> get props => [seatAllocations];
}

class BranchSeatAllocationError extends BranchState{
  final String message;
  const BranchSeatAllocationError({required this.message});
  @override
  List<Object?> get props => [message];
}

class BranchesLoaded extends BranchState {
  final List<Branch> branches;
  const BranchesLoaded(this.branches);
  @override
  List<Object?> get props => [branches];
}

class LoadedCoursesForBranchState extends BranchState {
  final List<Course> courses;
  const LoadedCoursesForBranchState(this.courses);
  @override
  List<Object?> get props => [courses];
}

class BranchFailureState extends BranchState {
  final String errorMessage;
  const BranchFailureState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
