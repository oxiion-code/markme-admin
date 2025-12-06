import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable{
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}
class LoadAttendanceForCurrentSessionEvent extends AttendanceEvent{
  final String attendanceId;
  const LoadAttendanceForCurrentSessionEvent({required this.attendanceId});
  @override
  List<Object?> get props => [attendanceId];
}