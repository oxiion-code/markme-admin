import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

class AcademicBatchState extends Equatable{
  const AcademicBatchState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AcademicBatchInitial extends AcademicBatchState{

}
class AcademicBatchLoading extends AcademicBatchState{

}
class AcademicBatchAdded extends AcademicBatchState{

}
class AcademicBatchDeleted extends AcademicBatchState{

}
class AcademicBatchUpdated extends AcademicBatchState{

}
class AcademicBatchError extends AcademicBatchState{
  final String message;
  const AcademicBatchError(this.message);
  @override
  List<Object?> get props => [message];
}
class AcademicBatchesLoaded extends AcademicBatchState{
  final List<AcademicBatch> batches;
  const AcademicBatchesLoaded(this.batches);
  @override
  List<Object?> get props => [batches];
}
class BranchesLoaded extends AcademicBatchState{
  final List<Branch> branches;
  const BranchesLoaded(this.branches);
  @override
  // TODO: implement props
  List<Object?> get props => [branches];
}