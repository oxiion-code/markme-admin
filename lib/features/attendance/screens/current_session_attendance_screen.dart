import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/attendance/bloc/attendance_events.dart';
import 'package:markme_admin/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_admin/features/classes/models/class_session.dart';

import '../bloc/attendance_state.dart';
import '../widgets/attendance_summary_widget.dart';
import '../widgets/class_session_details_widget.dart';
import '../widgets/student_tile.dart';


class CurrentSessionAttendanceScreen extends StatefulWidget {
  final ClassSession classSession;
  const CurrentSessionAttendanceScreen({super.key, required this.classSession});

  @override
  State<CurrentSessionAttendanceScreen> createState() =>
      _CurrentSessionAttendanceScreenState();
}

class _CurrentSessionAttendanceScreenState
    extends State<CurrentSessionAttendanceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(
      LoadAttendanceForCurrentSessionEvent(
        attendanceId: widget.classSession.attendanceId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Details'),
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AttendanceError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is AttendanceForCurrentDayLoaded) {
            final studentsWithStatus = state.studentsWithStatus;

            int total = studentsWithStatus.length;
            int presentCount =
                studentsWithStatus.where((s) => s.isPresent).length;
            int absentCount = total - presentCount;

            return Column(
              children: [
                ClassSessionDetailsWidget(session: widget.classSession),
                const SizedBox(height: 10),
                AttendanceSummaryWidget(
                  total: total,
                  present: presentCount,
                  absent: absentCount,
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: studentsWithStatus.length,
                    itemBuilder: (context, index) {
                      final data = studentsWithStatus[index];
                      return StudentTile(studentWithStatus: data);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}