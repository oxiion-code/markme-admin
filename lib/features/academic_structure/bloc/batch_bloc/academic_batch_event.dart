
import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';

class AcademicBatchEvent extends Equatable{
  const AcademicBatchEvent();
  @override
  List<Object?> get props => [];
}

class AddBatchEvent extends AcademicBatchEvent{
  final AcademicBatch batch;
  final String collegeId;
  const AddBatchEvent(this.batch, this.collegeId);
  @override
  List<Object?> get props => [batch];
}

class UpdateBatchEvent extends AcademicBatchEvent{
  final AcademicBatch batch;
  final String collegeId;
  const UpdateBatchEvent({required this.batch, required this.collegeId});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteBatchEvent extends AcademicBatchEvent{
  final AcademicBatch batch;
  final String collegeId;
  const DeleteBatchEvent({required this.batch, required this.collegeId});
  @override
  List<Object?> get props => [batch];
}
 class LoadAllBatchesEvent extends AcademicBatchEvent{
  final String branchId;
  final String collegeId;
  const LoadAllBatchesEvent({required this.branchId, required this.collegeId});
  @override
  List<Object?> get props => [branchId];
 }

 class LoadAllBranchesEvent extends AcademicBatchEvent{
  final String collegeId;
  const LoadAllBranchesEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
 }