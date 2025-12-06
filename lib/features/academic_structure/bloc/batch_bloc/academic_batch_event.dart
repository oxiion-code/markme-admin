
import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';

class AcademicBatchEvent extends Equatable{
  const AcademicBatchEvent();
  @override
  List<Object?> get props => [];
}

class AddBatchEvent extends AcademicBatchEvent{
  final AcademicBatch batch;
  const AddBatchEvent(this.batch);
  @override
  List<Object?> get props => [batch];
}

class UpdateBatchEvent extends AcademicBatchEvent{
  final AcademicBatch batch;
  const UpdateBatchEvent(this.batch);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteBatchEvent extends AcademicBatchEvent{
  final AcademicBatch batch;
  const DeleteBatchEvent(this.batch);
  @override
  // TODO: implement props
  List<Object?> get props => [batch];
}
 class LoadAllBatchesEvent extends AcademicBatchEvent{
  final String branchId;
  const LoadAllBatchesEvent({required this.branchId});
  @override
  List<Object?> get props => [branchId];
 }

 class LoadAllBranchesEvent extends AcademicBatchEvent{

 }