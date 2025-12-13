import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/branch_seat_allocation.dart';

class BranchEvent extends Equatable {
  const BranchEvent();
  @override
  List<Object?> get props => [];
}

class AddNewBranchEvent extends BranchEvent {
  final String collegeId;
  final Branch branch;
  const AddNewBranchEvent({required this.branch, required this.collegeId});
  @override
  List<Object?> get props => [branch];
}

class UpdateBranchEvent extends BranchEvent {
  final String collegeId;
  final Branch branch;
  const UpdateBranchEvent({required this.branch, required this.collegeId});
  @override
  List<Object?> get props => [branch];
}

class LoadBranchesEvent extends BranchEvent {
  final String collegeId;
  const LoadBranchesEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}

class LoadCourseForBranchEvent extends BranchEvent {
  final String collegeId;
  const LoadCourseForBranchEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}

class DeleteBranchEvent extends BranchEvent {
  final Branch branch;
  final String collegeId;
  const DeleteBranchEvent({required this.branch, required this.collegeId});
  @override
  List<Object?> get props => [branch];
}

class AddBranchSeatAllocationEvent extends BranchEvent {
  final BranchSeatAllocation seatAllocation;
  final String collegeId;
  const AddBranchSeatAllocationEvent({
    required this.collegeId,
    required this.seatAllocation,
  });
  @override
  List<Object?> get props => [seatAllocation, collegeId];
}

class DeleteBranchSeatAllocationEvent extends BranchEvent {
  final String collegeId;
  final BranchSeatAllocation seatAllocation;
  const DeleteBranchSeatAllocationEvent({
    required this.collegeId,
    required this.seatAllocation,
  });
  @override
  List<Object?> get props => [collegeId, seatAllocation];
}

class UpdateBranchSeatAllocationEvent extends BranchEvent {
  final String collegeId;
  final BranchSeatAllocation seatAllocation;
  const UpdateBranchSeatAllocationEvent({
    required this.collegeId,
    required this.seatAllocation,
  });
  @override
  List<Object?> get props => [collegeId, seatAllocation];
}
class LoadBranchSeatAllocationsEvent extends BranchEvent{
  final String collegeId;
  final String branchId;
  const LoadBranchSeatAllocationsEvent({required this.collegeId, required this.branchId});
  @override
  List<Object?> get props => [collegeId,branchId];
  }
