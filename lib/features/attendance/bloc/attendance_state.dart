import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/attendance/model/student_with_status.dart';

abstract class AttendanceState extends Equatable{
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

class AttendanceLoading extends AttendanceState{

}
class AttendanceInitial extends AttendanceState{

}
class AttendanceError extends AttendanceState{
  final String message;
  const AttendanceError({required this.message});
  @override
  List<Object?> get props =>[message];
}
class AttendanceForCurrentDayLoaded extends AttendanceState{
  final List<StudentWithStatus> studentsWithStatus;
  const AttendanceForCurrentDayLoaded({required this.studentsWithStatus});
  @override
  List<Object?> get props => [studentsWithStatus];
}