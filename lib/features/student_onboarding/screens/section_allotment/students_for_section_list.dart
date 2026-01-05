import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

import 'package:markme_admin/features/student_onboarding/bloc/student_verification_event.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_state.dart';

import '../../bloc/student_verification_bloc.dart';
import '../../models/student_list_args.dart';

class SectionAllotmentScreen extends StatefulWidget {
  final StudentListArgs args;

  const SectionAllotmentScreen({super.key, required this.args});

  @override
  State<SectionAllotmentScreen> createState() => _SectionAllotmentScreenState();
}

class _SectionAllotmentScreenState extends State<SectionAllotmentScreen> {
  final Set<String> selectedStudentIds = {};

  int get availableSeats => widget.args.section!.availableSeats;
  int get totalStudents => widget.args.students.length;

  bool get isAllSelected =>
      selectedStudentIds.length == min(totalStudents, availableSeats);

  bool get isFull => selectedStudentIds.length >= availableSeats;
  double get selectionProgress => availableSeats > 0
      ? selectedStudentIds.length / availableSeats
      : 0.0;

  void _toggleSelectAll(bool? value) {
    if (value == null) return;

    setState(() {
      selectedStudentIds.clear();
      if (value) {
        selectedStudentIds.addAll(
          widget.args.students.take(availableSeats).map((s) => s.id),
        );
      }
    });
  }

  void _toggleStudent(String studentId) {
    setState(() {
      if (selectedStudentIds.contains(studentId)) {
        selectedStudentIds.remove(studentId);
      } else if (!isFull) {
        selectedStudentIds.add(studentId);
      }
    });
  }

  void _assignSection() {
    HapticFeedback.mediumImpact();
    final selectedStudents = widget.args.students
        .where((s) => selectedStudentIds.contains(s.id))
        .toList();
    final batchList = widget.args.section!.batchId.split("_");
    final allocationId = "${batchList[0]}_${batchList[1]}";

    context.read<StudentOnboardingBloc>().add(
      AssignSectionToStudentsEvent(
        collegeId: widget.args.collegeId,
        sectionId: widget.args.sectionId!,
        allocationId: allocationId,
        students: selectedStudents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<StudentOnboardingBloc, StudentOnboardingState>(
      listener: (context, state) {
        if (state is AssignedSectionToStudents) {
          AppUtils.showCustomSnackBar(context, "Assigned sections to ${selectedStudentIds.length} students");
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Section Allotment'),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Section Info
              _buildSectionInfo(theme),

              // Progress
              _buildProgress(theme),

              // Students List
              Expanded(child: _buildStudentList(theme)),

              // Action Button
              _buildActionButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionInfo(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.args.section!.sectionName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalStudents students',
                  style: theme.textTheme.bodyMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_seat, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$availableSeats seats',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: selectionProgress,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${selectedStudentIds.length} / $availableSeats selected'),
              Checkbox(
                value: isAllSelected,
                tristate: true,
                onChanged: _toggleSelectAll,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.people_outline, color: theme.colorScheme.primary),
            title: Text(
              'Students (${widget.args.students.length})',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: widget.args.students.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = widget.args.students[index];
                final isSelected = selectedStudentIds.contains(student.id);
                final isDisabled = !isSelected && isFull;

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: isDisabled ? null : (_) => _toggleStudent(student.id),
                  title: Text(
                    student.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text('Roll: ${student.rollNo}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: isDisabled
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.block, color: Colors.orange, size: 20),
                  )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<StudentOnboardingBloc, StudentOnboardingState>(
        builder: (context, state) {
          final isLoading = state is StudentVerificationLoading;

          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading || selectedStudentIds.isEmpty
                  ? null
                  : _assignSection,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Assign ${selectedStudentIds.length} Students',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}
