import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

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
