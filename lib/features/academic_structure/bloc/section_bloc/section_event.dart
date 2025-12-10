import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';

class SectionEvent extends Equatable{
  const SectionEvent();
  @override
  List<Object?> get props => [];
}

class AddNewSectionEvent extends SectionEvent{
  final Section section;
  final String collegeId;
  const AddNewSectionEvent({required this.section, required this.collegeId});
  @override
  List<Object?> get props => [section];
}

class DeleteSectionEvent extends SectionEvent{
  final Section section;
  final String collegeId;
  const DeleteSectionEvent({required this.section, required this.collegeId});
  @override
  List<Object?> get props => [section];
}
class UpdateSectionEvent extends  SectionEvent{
  final Section section;
  final String collegeId;
  const UpdateSectionEvent({required this.section,required this.collegeId});
  @override
  List<Object?> get props => [section];
}
class LoadAllSectionEvent extends SectionEvent{
  final String branchId;
  final String collegeId;
  const LoadAllSectionEvent({required this.branchId, required this.collegeId});
  @override
  List<Object?> get props => [branchId];
}

class LoadAllBatchesEvent extends SectionEvent{
  final String branchId;
  final String collegeId;
  const LoadAllBatchesEvent({required this.branchId, required this.collegeId});
  @override
  List<Object?> get props => [branchId];
}
class LoadTeachersForSection extends SectionEvent{
  final String branchId;
  final String collegeId;
  const LoadTeachersForSection({required this. branchId, required this.collegeId});
  @override
  List<Object?> get props => [branchId];
}
class LoadAllBranchesEvent extends SectionEvent{
  final String collegeId;
  const LoadAllBranchesEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}