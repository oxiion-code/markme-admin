import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

class BranchEvent extends Equatable {
  const BranchEvent();
  @override
  List<Object?> get props => [];
}

class AddNewBranchEvent extends BranchEvent {
  final Branch branch;
  const AddNewBranchEvent(this.branch);
  @override
  List<Object?> get props => [branch];
}

class UpdateBranchEvent extends BranchEvent {
  final Branch branch;
  const UpdateBranchEvent(this.branch);
  @override
  List<Object?> get props => [branch];
}

class LoadBranchesEvent extends BranchEvent {}

class LoadCourseForBranchEvent extends BranchEvent {}

class DeleteBranchEvent extends BranchEvent {
  final Branch branch;
  const DeleteBranchEvent(this.branch);
  @override
  List<Object?> get props => [branch];
}
