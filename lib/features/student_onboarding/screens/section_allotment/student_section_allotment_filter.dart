import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/data/models/student.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_bloc.dart';
import 'package:markme_admin/features/student_onboarding/bloc/student_verification_state.dart';

import '../../../academic_structure/models/section.dart';
import '../../bloc/student_verification_event.dart';
import '../../models/student_list_args.dart';
class SectionAllotmentFilterScreen extends StatefulWidget {
  final String collegeId;

  const SectionAllotmentFilterScreen({
    super.key,
    required this.collegeId,
  });

  @override
  State<SectionAllotmentFilterScreen> createState() =>
      _SectionAllotmentFilterScreenState();
}

class _SectionAllotmentFilterScreenState
    extends State<SectionAllotmentFilterScreen> {
  String? selectedCourseId;
  String? selectedBranchId;
  String? selectedBatchId;
  String? selectedSectionId;
  Section? selectedSection;

  List<Course> courses = [];
  List<Branch> branches = [];
  List<AcademicBatch> batches = [];
  List<Student> students = [];
  List<Section> sections = [];

  bool studentsLoaded = false;
  bool sectionsLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<StudentOnboardingBloc>().add(
      LoadCoursesForStudentEvent(collegeId: widget.collegeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Section Allotment'),
        centerTitle: true,
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

          if (state is LoadedStudentsForSectionAllotment) {
            students = state.students;
            studentsLoaded = true;

            /// 🔥 LOAD SECTIONS AFTER STUDENTS
            context.read<StudentOnboardingBloc>().add(
              LoadSectionsForStudentEvent(
                collegeId: widget.collegeId,
                branchId: selectedBranchId!,
                batchId: selectedBatchId!,
              ),
            );
          }

          if (state is LoadedSectionsForStudent) {
            sections = state.sections;
            sectionsLoaded = true;
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
                /// -------- STATUS --------
                Row(
                  children: [
                    Icon(
                      studentsLoaded
                          ? Icons.check_circle
                          : Icons.group_add,
                      color: studentsLoaded
                          ? Colors.green
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        studentsLoaded
                            ? '${students.length} students loaded'
                            : 'Select batch to load students',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// -------- FILTER CARD --------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// COURSE
                        DropdownButtonFormField<String>(
                          value: selectedCourseId,
                          decoration:
                          const InputDecoration(labelText: 'Course'),
                          items: courses
                              .map(
                                (c) => DropdownMenuItem(
                              value: c.courseId,
                              child: Text(c.courseName),
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
                              selectedSectionId = null;
                              studentsLoaded = false;
                              sectionsLoaded = false;
                              branches.clear();
                              batches.clear();
                              sections.clear();
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
                        ),

                        const SizedBox(height: 12),

                        /// BRANCH
                        DropdownButtonFormField<String>(
                          value: selectedBranchId,
                          decoration:
                          const InputDecoration(labelText: 'Branch'),
                          items: branches
                              .map(
                                (b) => DropdownMenuItem(
                              value: b.branchId,
                              child: Text(b.branchName),
                            ),
                          )
                              .toList(),
                          onChanged: isLoading
                              ? null
                              : (value) {
                            setState(() {
                              selectedBranchId = value;
                              selectedBatchId = null;
                              selectedSectionId = null;
                              studentsLoaded = false;
                              sectionsLoaded = false;
                              batches.clear();
                              sections.clear();
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
                        ),

                        const SizedBox(height: 12),

                        /// BATCH
                        DropdownButtonFormField<String>(
                          value: selectedBatchId,
                          decoration:
                          const InputDecoration(labelText: 'Batch'),
                          items: batches
                              .map(
                                (b) => DropdownMenuItem(
                              value: b.batchId,
                              child: Text(b.batchId),
                            ),
                          )
                              .toList(),
                          onChanged: isLoading
                              ? null
                              : (value) {
                            setState(() {
                              selectedBatchId = value;
                              selectedSectionId = null;
                              studentsLoaded = false;
                              sectionsLoaded = false;
                              sections.clear();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        /// 🔥 SECTION DROPDOWN
                        if (sectionsLoaded)
                          DropdownButtonFormField<String>(
                            value: selectedSectionId,
                            decoration: const InputDecoration(
                              labelText: 'Section',
                            ),
                            items: sections
                                .map(
                                  (s) => DropdownMenuItem(
                                value: s.sectionId,
                                child: Text(
                                  '${s.sectionName} (Seats: ${s.availableSeats})',
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSectionId = value;
                                selectedSection =
                                sections.firstWhere((s) => s.sectionId == value);
                              });
                            },
                          ),
                        const SizedBox(height: 12,),
                        FilledButton(onPressed: (){
                          setState(() {
                            selectedCourseId = null;
                            selectedBranchId = null;
                            selectedBatchId = null;
                            selectedSectionId = null;
                            studentsLoaded = false;
                            sectionsLoaded = false;
                            branches.clear();
                            batches.clear();
                            sections.clear();
                          });
                        }, child: Text("Reset Selection"))
                      ],
                    ),
                  ),
                ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      if (!studentsLoaded) {
                        context
                            .read<StudentOnboardingBloc>()
                            .add(
                          GetStudentsForSectionAllotmentEvent(
                            collegeId: widget.collegeId,
                            courseId: selectedCourseId!,
                            batchId: selectedBatchId!,
                          ),
                        );
                      } else if (selectedSectionId != null && selectedSection!=null) {
                        context.push(
                          '/section-allotment-list',
                          extra: StudentListArgs(
                            collegeId: widget.collegeId,
                            students: students,
                            sectionId: selectedSectionId!,
                            section: selectedSection!
                          ),
                        ).then((res){
                          setState(() {
                            selectedCourseId = null;
                            selectedBranchId = null;
                            selectedBatchId = null;
                            selectedSectionId = null;
                            studentsLoaded = false;
                            sectionsLoaded = false;
                            branches.clear();
                            batches.clear();
                            sections.clear();
                          });
                        });
                      }
                    },
                    child: Text(
                      studentsLoaded
                          ? 'Proceed to Allotment'
                          : 'Load Students',
                    ),
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
