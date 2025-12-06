import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_state.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/subjects/models/subject.dart';

class SubjectState extends Equatable{
  const SubjectState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState{}
class SubjectLoading extends SubjectState{}
class SubjectSuccess extends SubjectState{}
class SubjectError extends SubjectState{
  final String message;
  const SubjectError(this.message);
  @override
  List<Object?> get props => [message];
}
class SubjectLoaded extends SubjectState{
  final List<Subject> subjects;
  const SubjectLoaded(this.subjects);
  @override
  List<Object?> get props => [subjects];
}
class BranchesLoaded extends SubjectState{
  final List<Branch> branches;
  const BranchesLoaded(this.branches);
  @override
  List<Object?> get props => [branches];
}
class BatchesLoaded extends SubjectState{
  final List<AcademicBatch> batches;
  const BatchesLoaded(this.batches);
  @override
  List<Object?> get props => [batches];
}