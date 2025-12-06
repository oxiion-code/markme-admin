import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/attendance/bloc/attendance_events.dart';
import 'package:markme_admin/features/attendance/bloc/attendance_state.dart';
import 'package:markme_admin/features/attendance/repositories/attendance_repository.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository attendanceRepository;
  AttendanceBloc({required this.attendanceRepository})
    : super(AttendanceInitial()) {
    on<LoadAttendanceForCurrentSessionEvent>(_loadAttendance);
  }

  FutureOr<void> _loadAttendance(
    LoadAttendanceForCurrentSessionEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(AttendanceLoading());
      final result = await attendanceRepository.getAttendanceStudentsById(
        event.attendanceId,
      );
      result.fold(
        (failure) => emit(AttendanceError(message: failure.message)),
        (studentsWithStatus) => emit(
          AttendanceForCurrentDayLoaded(studentsWithStatus: studentsWithStatus),
        ),
      );
    } catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }
}
