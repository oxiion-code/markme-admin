import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/time_extension.dart';
import 'package:markme_admin/features/settings/bloc/setting_bloc.dart';
import 'package:markme_admin/features/settings/bloc/setting_event.dart';
import 'package:markme_admin/features/settings/bloc/setting_state.dart';

import '../../onboarding/models/college_detail.dart';
import '../../onboarding/models/user_model.dart';
import '../models/class_schedule.dart';

class CollegeScheduleDetailsScreen extends StatefulWidget {
  final AdminUser adminUser;

  const CollegeScheduleDetailsScreen({super.key, required this.adminUser});

  @override
  State<CollegeScheduleDetailsScreen> createState() =>
      _CollegeScheduleDetailsScreenState();
}

class _CollegeScheduleDetailsScreenState
    extends State<CollegeScheduleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(
      LoadCollegeDetailEvent(collegeId: widget.adminUser.collegeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Class Schedule'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push("/addCollegeSchedule",extra: widget.adminUser).then((res){
            if(res=="uploaded"){
              context.read<SettingBloc>().add(
                LoadCollegeDetailEvent(collegeId: widget.adminUser.collegeId),
              );
            }
          });
        },
        label: Text("Add Schedule"),
        icon: Icon(Icons.add),
      ),
      body: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          if (state is SettingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingError) {
            return Center(child: Text(state.message));
          }
          if (state is CollegeDetailsLoaded) {
            final CollegeDetail collegeDetail = state.collegeDetail;
            final CollegeSchedule? collegeSchedule =
                collegeDetail.collegeSchedule;

            if (collegeSchedule == null || collegeSchedule.schedules.isEmpty) {
              return const Center(child: Text('No class schedule added yet'));
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ------------------ Summary Card ------------------
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoRow(
                            icon: Icons.class_,
                            label: 'Number of Classes',
                            value: collegeSchedule.numberOfClasses.toString(),
                          ),
                          const SizedBox(height: 8),
                          _infoRow(
                            icon: Icons.timer,
                            label: 'Duration per Class',
                            value: '${collegeSchedule.durationMinutes} minutes',
                          ),
                          const Divider(height: 24),
                          _infoRow(
                            icon: Icons.schedule,
                            label: 'Total Duration',
                            value:
                                '${collegeSchedule.durationMinutes * collegeSchedule.schedules.length} minutes',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ------------------ Sessions Title ------------------
                  Text(
                    'Daily Sessions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ------------------ Sessions List ------------------
                  Expanded(
                    child: ListView.separated(
                      itemCount: collegeSchedule.schedules.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final session = collegeSchedule.schedules[index];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                session.index.toString(),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              '${session.startMinute.formatTime()} - '
                              '${session.endMinute.formatTime()}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Duration: ${session.endMinute - session.startMinute} mins',
                            ),
                            trailing: const Icon(Icons.access_time),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
