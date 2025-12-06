import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/subjects/models/subject.dart';

class SubjectEvent extends Equatable{
  const SubjectEvent();
  @override
  List<Object?> get props => [];
}
class AddSubjectEvent extends SubjectEvent{
  final Subject subject;
  const AddSubjectEvent(this.subject);
  @override
  // TODO: implement props
  List<Object?> get props => [subject];
}

class UpdateSubjectEvent extends SubjectEvent{
  final Subject subject;
  const UpdateSubjectEvent(this.subject);
  @override
  // TODO: implement props
  List<Object?> get props => [subject];
}
class DeleteSubjectEvent extends SubjectEvent{
  final Subject subject;
  const DeleteSubjectEvent(this.subject);
  @override
  List<Object?> get props => [];
}

class GetAllSubjects extends SubjectEvent{
}
class GetAllBranches extends SubjectEvent{

}
class GetAllBatches extends SubjectEvent{
  final String branchId;
  const GetAllBatches(this.branchId);
  @override
  // TODO: implement props
  List<Object?> get props =>[branchId];
}
