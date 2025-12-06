import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';

import '../../models/branch.dart';

class BranchState extends Equatable {
  const BranchState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BranchInitialState extends BranchState {}

class BranchDataLoadingState extends BranchState {}

class BranchSuccess extends BranchState {}

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
