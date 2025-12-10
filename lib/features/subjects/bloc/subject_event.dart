import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/subjects/models/subject.dart';

class SubjectEvent extends Equatable{
  const SubjectEvent();
  @override
  List<Object?> get props => [];
}
class AddSubjectEvent extends SubjectEvent{
  final Subject subject;
  final String collegeId;
  const AddSubjectEvent(this.subject, this.collegeId);
  @override
  List<Object?> get props => [subject];
}

class UpdateSubjectEvent extends SubjectEvent{
  final Subject subject;
  final String collegeId;
  const UpdateSubjectEvent(this.subject, this.collegeId);
  @override
  List<Object?> get props => [subject];
}
class DeleteSubjectEvent extends SubjectEvent{
  final Subject subject;
  final String collegeId;
  const DeleteSubjectEvent(this.subject, this.collegeId);
  @override
  List<Object?> get props => [];
}

class GetAllSubjects extends SubjectEvent{
  final String collegeId;
  const GetAllSubjects({required this.collegeId});
  @override
  // TODO: implement props
  List<Object?> get props => [collegeId];
}
class LoadAllBranches extends SubjectEvent{
  final String collegeId;
  const LoadAllBranches({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
class LoadAllBatches extends SubjectEvent{
  final String collegeId;
  final String branchId;
  const LoadAllBatches({required this.collegeId, required this.branchId});
  @override
  // TODO: implement props
  List<Object?> get props =>[branchId];
}
