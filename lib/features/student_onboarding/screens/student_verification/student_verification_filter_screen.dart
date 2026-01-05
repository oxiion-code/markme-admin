import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/data/models/student.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_event.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_state.dart';
import 'package:markme_admin/features/student_onboarding/models/student_list_args.dart';

import '../../bloc/student_verification_bloc.dart';

class StudentVerificationFilterScreen extends StatefulWidget {
  final String collegeId;

  const StudentVerificationFilterScreen({
    super.key,
    required this.collegeId,
  });

  @override
  State<StudentVerificationFilterScreen> createState() =>
      _StudentVerificationFilterScreenState();
}

class _StudentVerificationFilterScreenState
    extends State<StudentVerificationFilterScreen> {
  /// ---------------- SELECTED IDS ----------------
  String? selectedCourseId;
  String? selectedBranchId;
  String? selectedBatchId;

  /// ---------------- DATA ----------------
  List<Course> courses = [];
  List<Branch> branches = [];
  List<AcademicBatch> batches = [];
  List<Student> students=[];

  bool studentsLoaded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Verification'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<StudentOnboardingBloc, StudentOnboardingState>(
        listener: (context, state) {
          if (state is CoursesLoadedForStudentVerification) {
            courses = state.courses;
          }

          if (state is BranchesLoadedForStudentVerification) {
            branches = state.branches;
          }

          if (state is BatchesLoadedForStudentVerification) {
            batches = state.batches;
          }

          if (state is LoadedStudentsForVerification) {
            studentsLoaded = true;
            setState(() {
              students=state.students;
            });
          }

          if (state is StudentVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is StudentVerificationLoading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ---------------- PROGRESS / STATUS ----------------
                Row(
                  children: [
                    Icon(
                      studentsLoaded
                          ? Icons.verified_rounded
                          : Icons.person_search_rounded,
                      color: studentsLoaded
                          ? Colors.green
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        studentsLoaded
                            ? '${students.length} Students loaded. Ready to start verification.'
                            : 'Select filters and load students for verification.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// ---------------- FILTER CARD ----------------
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filters',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (courses.isNotEmpty)
                          DropdownButtonFormField<String>(
                            initialValue: selectedCourseId,
                            decoration: InputDecoration(
                              labelText: 'Select Course',
                              prefixIcon: const Icon(Icons.school_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              isDense: true,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ), // custom dropdown icon [web:4]
                            items: courses
                                .map<DropdownMenuItem<String>>(
                                  (course) => DropdownMenuItem<String>(
                                value: course.courseId,
                                child: Text(course.courseName),
                              ),
                            )
                                .toList(),
                            onChanged: isLoading
                                ? null
                                : (value) {
                              setState(() {
                                selectedCourseId = value;
                                selectedBranchId = null;
                                selectedBatchId = null;
                                branches.clear();
                                batches.clear();
                                studentsLoaded = false;
                              });

                              if (value != null) {
                                context
                                    .read<StudentOnboardingBloc>()
                                    .add(
                                  LoadBranchesForStudentEvent(
                                    collegeId: widget.collegeId,
                                    courseId: value,
                                  ),
                                );
                              }
                            },
                          )
                        else
                          const _ShimmerDropdownPlaceholder(
                            label: 'Loading courses...',
                            icon: Icons.school_rounded,
                          ),

                        const SizedBox(height: 16),

                        /// ---------------- BRANCH ----------------
                        if (branches.isNotEmpty)
                          DropdownButtonFormField<String>(
                            value: selectedBranchId,
                            decoration: InputDecoration(
                              labelText: 'Select Branch',
                              prefixIcon: const Icon(Icons.account_tree_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              isDense: true,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                            items: branches
                                .map<DropdownMenuItem<String>>(
                                  (branch) => DropdownMenuItem<String>(
                                value: branch.branchId,
                                child: Text(branch.branchName),
                              ),
                            )
                                .toList(),
                            onChanged: isLoading
                                ? null
                                : (value) {
                              setState(() {
                                selectedBranchId = value;
                                selectedBatchId = null;
                                batches.clear();
                                studentsLoaded = false;
                              });

                              if (value != null) {
                                context
                                    .read<StudentOnboardingBloc>()
                                    .add(
                                  LoadAcademicBatchesForStudentEvent(
                                    collegeId: widget.collegeId,
                                    branchId: value,
                                  ),
                                );
                              }
                            },
                          )
                        else
                          IgnorePointer(
                            ignoring: true,
                            child: DropdownButtonFormField<String>(
                              value: null,
                              decoration: InputDecoration(
                                labelText: 'Select Branch',
                                prefixIcon:
                                const Icon(Icons.account_tree_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                isDense: true,
                              ),
                              items: const [],
                              onChanged: (_) {},
                            ),
                          ),

                        const SizedBox(height: 16),

                        /// ---------------- BATCH ----------------
                        if (batches.isNotEmpty)
                          DropdownButtonFormField<String>(
                            value: selectedBatchId,
                            decoration: InputDecoration(
                              labelText: 'Select Batch',
                              prefixIcon: const Icon(Icons.group_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              isDense: true,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                            items: batches
                                .map<DropdownMenuItem<String>>(
                                  (batch) => DropdownMenuItem<String>(
                                value: batch.batchId,
                                child: Text(batch.batchId.toUpperCase()),
                              ),
                            )
                                .toList(),
                            onChanged: isLoading
                                ? null
                                : (value) {
                              setState(() {
                                selectedBatchId = value;
                                studentsLoaded = false;
                              });
                            },
                          )
                        else
                          IgnorePointer(
                            ignoring: true,
                            child: DropdownButtonFormField<String>(
                              value: null,
                              decoration: InputDecoration(
                                labelText: 'Select Batch',
                                prefixIcon: const Icon(Icons.group_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                isDense: true,
                              ),
                              items: const [],
                              onChanged: (_) {},
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                /// ---------------- ACTION BUTTON + LOADING ----------------
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: studentsLoaded
                        ? const Icon(Icons.play_arrow_rounded)
                        : const Icon(Icons.download_rounded),
                    label: Text(
                      studentsLoaded ? 'Start Verification' : 'Load Students',
                    ),
                    onPressed: (selectedBatchId == null || isLoading)
                        ? null
                        : () {
                      if (!studentsLoaded) {
                        context
                            .read<StudentOnboardingBloc>()
                            .add(
                          GetStudentsForVerificationEvent(
                            collegeId: widget.collegeId,
                            courseId: selectedCourseId!,
                            branchId: selectedBranchId!,
                            batchId: selectedBatchId!,
                          ),
                        );
                      } else {
                        final args=StudentListArgs(collegeId: widget.collegeId, students: students);
                        context.push('/student-verification-list',extra: args);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                if (isLoading) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Please wait...'),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Simple skeleton-style placeholder for loading dropdown
class _ShimmerDropdownPlaceholder extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ShimmerDropdownPlaceholder({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: DropdownButtonFormField<String>(
        initialValue: null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          isDense: true,
        ),
        items: const [],
        onChanged: (_) {},
      ),
    );
  }
}
