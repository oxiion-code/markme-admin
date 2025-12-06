import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

import 'package:markme_admin/features/current_session/bloc/current_session_event.dart';
import 'package:markme_admin/features/dashboard/widgets/app_bar.dart';
import 'package:markme_admin/features/dashboard/widgets/dashboard_drawer.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import '../../current_session/bloc/current_session_bloc.dart';
import '../../current_session/bloc/current_session_state.dart';

// Utilities
String formatSection(String rawSectionId, String sectionName) {
  final parts = rawSectionId.split('_');
  if (parts.length >= 4) {
    final fromYear = parts[1];
    final toYear = parts[2];
    return "$sectionName ($fromYear-$toYear)";
  }
  return sectionName;
}

String formatDateTimeFromEpoch(num epoch, {bool showDate = true}) {
  final dt = DateTime.fromMillisecondsSinceEpoch(epoch.toInt());
  final formatter = DateFormat(showDate ? 'd MMM yyyy, hh:mm a' : 'hh:mm a');
  return formatter.format(dt);
}

String formatSessionTime(DateTime start, DateTime? end) {
  final startStr = DateFormat('hh:mm a').format(start);
  final endStr = end != null ? DateFormat('hh:mm a').format(end) : 'Ongoing';
  return "$startStr – $endStr";
}

// Main Dashboard
class DashboardScreen extends StatefulWidget {
  final AdminUser user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentSessionBloc>().add(LoadClassSessionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      drawer: DashboardDrawer(),
      body: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentSessionBloc, CurrentClassSessionState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<CurrentSessionBloc>().add(LoadClassSessionsEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/college_front.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Welcome to Dashboard',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    DateFormat('d MMM yyyy').format(DateTime.now()),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (state is CurrentSessionLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is CurrentSessionFailed)
                  _buildError(state.message)
                else if (state is LoadedCurrentClassSessions)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(
                          title: "Live Classes",
                          icon: Icons.play_circle_fill_rounded,
                          color: Colors.green[700]!,
                        ),
                        const SizedBox(height: 8),
                        if (state.liveSessions.isEmpty)
                          _emptySection("No live classes currently.")
                        else
                          ...state.liveSessions.map(
                            (s) => _SessionCard(
                              subject: s.subjectName,
                              teacher: s.teacherName,
                              section: formatSection(
                                s.sectionId,
                                s.sectionName,
                              ),
                              room: s.roomName,
                              sessionType: s.sessionType,
                              time: formatSessionTime(s.startTime, s.endTime),
                              status: 'Live',
                              statusColor: Colors.green,
                              icon: Icons.wifi_tethering_rounded,
                              onTap: () {
                                if (s.attendanceId != null) {
                                  context.push("/currentSessionAttendance",extra: s);
                                } else {
                                  AppUtils.showCustomSnackBar(context, "Attendance is not taken");
                                }
                              },
                              attendanceTaken: s.attendanceId != null,
                            ),
                          ),
                        const SizedBox(height: 24),
                        _SectionTitle(
                          title: "Recently Ended",
                          icon: Icons.history_rounded,
                          color: Colors.deepOrange[700]!,
                        ),
                        const SizedBox(height: 8),
                        if (state.pastSessions.isEmpty)
                          _emptySection("No recent classes yet.")
                        else
                          ...state.pastSessions.map(
                            (s) => _SessionCard(
                              subject: s.subjectName,
                              teacher: s.teacherName,
                              section: formatSection(
                                s.sectionId,
                                s.sectionName,
                              ),
                              sessionType: s.sessionType,
                              room: s.roomName,
                              time: formatSessionTime(s.startTime, s.endTime),
                              status: 'Ended',
                              statusColor: Colors.orange,
                              icon: Icons.assignment_turned_in_rounded,
                              onTap: () {
                                if (s.attendanceId != null) {
                                  context.push("/currentSessionAttendance",extra: s);
                                } else {
                                  AppUtils.showCustomSnackBar(context, "Attendance is not taken");
                                }
                              },
                              attendanceTaken: s.attendanceId != null,
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _emptySection(String text) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
          fontSize: 14,
        ),
      ),
    ),
  );

  Widget _buildError(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.redAccent, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final VoidCallback onTap;
  final String subject;
  final String teacher;
  final String section;
  final String sessionType;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;
  final String? room;
  final bool attendanceTaken;

  const _SessionCard({
    required this.subject,
    required this.teacher,
    required this.section,
    required this.sessionType,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.attendanceTaken,
    required this.onTap,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(icon, color: statusColor),
        ),
        title: Text(
          section,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$subject ($sessionType)\n$time",
                style: TextStyle(fontWeight: FontWeight.w600),
              ), //$subject ($sessionType)
              attendanceTaken
                  ? Text('Attendance Taken', style: const TextStyle(fontSize: 15, color: Colors.green,fontWeight: FontWeight.bold))
                  : Text('No Attendance', style: const TextStyle(fontSize: 15, color: Colors.red,fontWeight: FontWeight.bold)),
              Text('By $teacher', style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap
      ),
    );
  }
}
