import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

import '../../blocs/session/session_bloc.dart';
import '../../blocs/session/session_event.dart';
import '../../blocs/session/session_state.dart';
import '../../models/session/placement_form.dart';
import '../../models/session/placement_session.dart';

class TakeSessionAttendanceScreen extends StatefulWidget {
  final String collegeId;
  final PlacementSession session;
  final List<PlacementForm> applications;

  const TakeSessionAttendanceScreen({
    super.key,
    required this.collegeId,
    required this.session,
    required this.applications,
  });

  @override
  State<TakeSessionAttendanceScreen> createState() =>
      _TakeSessionAttendanceScreenState();
}

class _TakeSessionAttendanceScreenState
    extends State<TakeSessionAttendanceScreen> {

  /// studentId -> present
  final Map<String, bool> _attendanceMap = {};

  /// true if attendance already exists
  bool _alreadyTaken = false;

  @override
  void initState() {
    super.initState();
    // Load existing attendance
    context.read<PlacementSessionBloc>().add(
      GetSessionAttendanceEvent(
        collegeId: widget.collegeId,
        sessionId: widget.session.sessionId,
      ),
    );
  }

  void _saveAttendance() {
    context.read<PlacementSessionBloc>().add(
      MarkSessionAttendanceEvent(
        collegeId: widget.collegeId,
        sessionId: widget.session.sessionId,
        attendances: _attendanceMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_alreadyTaken ? 'Update Attendance' : 'Take Attendance'),
        centerTitle: true,
      ),
      body: BlocConsumer<PlacementSessionBloc, PlacementSessionState>(
        listener: (context, state) {
          // Load existing attendance
          if (state is LoadedAttendanceForSession) {
            _attendanceMap.clear();

            if (state.sessionAttendanceModel != null) {
              _attendanceMap.addAll(state.sessionAttendanceModel!.applicants);
              _alreadyTaken = true;
            } else {
              _alreadyTaken = false; // attendance not taken yet
            }
            setState(() {});
          }

          // Successfully saved
          if (state is AttendanceMarkedForSession) {
            AppUtils.showCustomSnackBar(context,    _alreadyTaken
                ? 'Attendance updated successfully'
                : 'Attendance taken successfully',);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is PlacementSessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PlacementSessionFailure) {
            return Center(child: Text(state.message));
          }

          return Column(
            children: [
              _SessionHeader(session: widget.session),
              if (_alreadyTaken)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Attendance already taken. You can update it.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
                  itemCount: widget.applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final app = widget.applications[index];
                    final studentId = app.studentId;

                    return _AttendanceTile(
                      application: app,
                      isPresent: _attendanceMap[studentId] ?? false,
                      onChanged: (value) {
                        setState(() {
                          _attendanceMap[studentId] = value;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: _attendanceMap.isEmpty ? null : _saveAttendance,
            icon: Icon(_alreadyTaken ? Icons.update : Icons.check_circle_outline),
            label: Text(_alreadyTaken ? 'Update Attendance' : 'Take Attendance'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}

/// SESSION HEADER
class _SessionHeader extends StatelessWidget {
  final PlacementSession session;
  const _SessionHeader({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.companyName,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(session.role,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.primary)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.date_range_outlined, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${_formatDate(session.startDate)} - ${_formatDate(session.endDate)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

/// STUDENT ATTENDANCE TILE
class _AttendanceTile extends StatelessWidget {
  final PlacementForm application;
  final bool isPresent;
  final ValueChanged<bool> onChanged;

  const _AttendanceTile({
    required this.application,
    required this.isPresent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = application.studentName ?? 'Student';
    final regNo = application.registrationNo ?? '-';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        value: isPresent,
        onChanged: onChanged,
        activeColor: Colors.green,
        title: Text(name,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500)),
        subtitle: Text('Reg no: $regNo',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.hintColor)),
        secondary: Icon(isPresent ? Icons.check_circle : Icons.cancel,
            color: isPresent ? Colors.green : Colors.red),
      ),
    );
  }
}
