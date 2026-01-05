import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/settings/bloc/setting_bloc.dart';
import 'package:markme_admin/features/settings/bloc/setting_event.dart';
import 'package:markme_admin/features/settings/bloc/setting_state.dart';
import '../models/class_schedule.dart';

class CollegeScheduleScreen extends StatefulWidget {
  final AdminUser adminUser;
  const CollegeScheduleScreen({super.key, required this.adminUser});

  @override
  State<CollegeScheduleScreen> createState() => _CollegeScheduleScreenState();
}

class _CollegeScheduleScreenState extends State<CollegeScheduleScreen> {
  final _formKeyClasses = GlobalKey<FormState>();
  final TextEditingController _classCountController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  int? _numberOfClasses;
  int? _durationMinutes;
  final List<TimeOfDay> _startTimes = [];
  final List<TimeOfDay> _endTimes = [];

  bool _isLoadingShown = false; // ✅ IMPORTANT

  @override
  void dispose() {
    _classCountController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  TimeOfDay _addDurationToTimeOfDay(TimeOfDay time, Duration duration) {
    final dt = DateTime(0, 1, 1, time.hour, time.minute).add(duration);
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  void _confirmNumberOfClasses() {
    if (_formKeyClasses.currentState!.validate()) {
      setState(() {
        _numberOfClasses = int.parse(_classCountController.text.trim());
        _startTimes.clear();
        _endTimes.clear();
      });
    }
  }

  Future<void> _pickAndAddTime() async {
    if (_numberOfClasses == null) {
      AppUtils.showCustomSnackBar(context, 'Please confirm number of classes first');
      return;
    }

    if (_startTimes.length >= _numberOfClasses!) {
      AppUtils.showCustomSnackBar(context, 'You already added $_numberOfClasses classes');
      return;
    }

    final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;

    if (hours == 0 && minutes == 0) {
      AppUtils.showCustomSnackBar(context, 'Please enter class duration');
      return;
    }

    final duration = Duration(hours: hours, minutes: minutes);
    _durationMinutes = hours * 60 + minutes;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final end = _addDurationToTimeOfDay(picked, duration);
      setState(() {
        _startTimes.add(picked);
        _endTimes.add(end);
      });
    }
  }

  void _removeClassTime(int index) {
    setState(() {
      _startTimes.removeAt(index);
      _endTimes.removeAt(index);
    });
  }

  void _submitSchedule() {
    if (_numberOfClasses == null || _durationMinutes == null) {
      AppUtils.showCustomSnackBar(context, 'Please confirm number of classes and duration first');
      return;
    }

    if (_startTimes.length != _numberOfClasses) {
      AppUtils.showCustomSnackBar(
        context,
        'Please add $_numberOfClasses schedules',
      );
      return;
    }

    final schedules = List.generate(_startTimes.length, (index) {
      return SessionModel(
        index: index + 1,
        startMinute: _timeOfDayToMinutes(_startTimes[index]),
        endMinute: _timeOfDayToMinutes(_endTimes[index]),
      );
    });

    final collegeSchedule = CollegeSchedule(
      numberOfClasses: _numberOfClasses!,
      durationMinutes: _durationMinutes!,
      schedules: schedules,
    );

    context.read<SettingBloc>().add(
      UploadCollegeScheduleEvent(
        collegeId: widget.adminUser.collegeId,
        collegeSchedule: collegeSchedule,
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        /// SHOW LOADING
        if (state is SettingLoading) {
          if (!_isLoadingShown) {
            _isLoadingShown = true;
            AppUtils.showCustomLoading(context);
          }
          return;
        }

        /// HIDE LOADING
        if (_isLoadingShown) {
          _isLoadingShown = false;
          Navigator.of(context, rootNavigator: true).pop();
        }

        /// SUCCESS
        if (state is CollegeScheduleUploaded) {
          AppUtils.showCustomSnackBar(
            context,
            "College schedule uploaded",
            isError: false,
          );
          context.pop("uploaded");
        }

        /// ERROR
        if (state is SettingError) {
          AppUtils.showCustomSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('College Class Schedule'),
          centerTitle: true,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKeyClasses,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _classCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Number of classes in a day',
                                  prefixIcon: Icon(Icons.looks_one_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter a number';
                                  }
                                  final numValue = int.tryParse(value.trim());
                                  if (numValue == null || numValue <= 0) {
                                    return 'Enter valid positive number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _confirmNumberOfClasses,
                              icon: const Icon(Icons.check),
                              label: const Text('Confirm'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Duration per class',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _hoursController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Hours',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _minutesController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Minutes',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_numberOfClasses != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'College schedules (${_startTimes.length} / $_numberOfClasses)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.access_time,
                        color: colorScheme.primary,
                      ),
                    ),
                    title: const Text('Tap to add class start time\n'),
                    subtitle: const Text('End time will be calculated using duration'),
                    trailing: FilledButton.icon(
                      onPressed: _pickAndAddTime,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Time'),
                    ),
                    onTap: _pickAndAddTime,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: _startTimes.isEmpty
                      ? Center(
                    child: Text(
                      'No college schedules added yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),
                  )
                      : SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_startTimes.length, (index) {
                        final start = _startTimes[index];
                        final end = _endTimes[index];
                        final label =
                            'Schedule ${index + 1} • ${_formatTimeOfDay(start)} - ${_formatTimeOfDay(end)}';
                        return Chip(
                          label: Text(label),
                          avatar: CircleAvatar(
                            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          backgroundColor: colorScheme.secondaryContainer,
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => _removeClassTime(index),
                        );
                      }),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submitSchedule,
                    icon: const Icon(Icons.save),
                    label: const Text('Add Class Schedule'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}