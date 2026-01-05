import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

import '../../academic_structure/bloc/section_bloc/section_bloc.dart';
import '../../academic_structure/bloc/section_bloc/section_event.dart';
import '../../academic_structure/bloc/section_bloc/section_state.dart';
import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../../academic_structure/models/course.dart';
import '../../academic_structure/models/section.dart';

class SectionPromotionScreen extends StatefulWidget {
  final String collegeId;

  const SectionPromotionScreen({
    super.key,
    required this.collegeId,
  });

  @override
  State<SectionPromotionScreen> createState() =>
      _SectionPromotionScreenState();
}

class _SectionPromotionScreenState extends State<SectionPromotionScreen> {
  /// 🔥 LOCAL STATE LISTS
  List<Course> courses = [];
  List<Branch> branches = [];
  List<AcademicBatch> batches = [];
  List<Section> sections = [];

  Course? selectedCourse;
  Branch? selectedBranch;
  AcademicBatch? selectedBatch;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<SectionBloc>().add(
      LoadCoursesForSection(collegeId: widget.collegeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promote Sections')),
      body: BlocConsumer<SectionBloc, SectionState>(
        listener: (context, state) {
          if (state is SectionLoading) {
            setState(() => isLoading = true);
          }

          /// ❌ ERROR
          if (state is SectionError) {
            setState(() => isLoading = false);
            AppUtils.showCustomSnackBar(context, state.message,isError: true);
          }

          /// ✅ COURSES
          if (state is CoursesLoaded) {
            setState(() {
              isLoading = false;
              courses = state.courses;
              branches.clear();
              batches.clear();
              sections.clear();
            });
          }

          /// ✅ BRANCHES
          if (state is BranchesLoaded) {
            setState(() {
              isLoading = false;
              branches = state.branches;
              batches.clear();
              sections.clear();
            });
          }

          /// ✅ BATCHES
          if (state is BatchesLoaded) {
            setState(() {
              isLoading = false;
              batches = state.batches;
              sections.clear();
            });
          }

          /// ✅ SECTIONS
          if (state is SectionsLoaded) {
            setState(() {
              isLoading = false;
              sections = state.sections;
            });
          }

          /// ✅ PROMOTED
          if (state is SectionPromoted) {
            setState(() => isLoading = false);
            AppUtils.showCustomSnackBar(context, "Section promoted successfully");
            if(selectedBranch!=null && selectedBatch != null){
              context.read<SectionBloc>().add(LoadSectionsForBatchEvent(collegeId: widget.collegeId, branchId: selectedBranch!.branchId, batchId:selectedBatch!.batchId));
            }

          }
        },
        builder: (context, state) {
          return Column(
            children: [
              /// 🔝 TOP LOADER
              if (isLoading)
                const LinearProgressIndicator(minHeight: 3),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ---------- COURSE ----------
                      DropdownButtonFormField<Course>(
                        decoration: const InputDecoration(
                          labelText: 'Select Course',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCourse,
                        items: courses
                            .map(
                              (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.courseName),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCourse = value;
                            selectedBranch = null;
                            selectedBatch = null;
                          });

                          context.read<SectionBloc>().add(
                            LoadAllBranchesEvent(
                              collegeId: widget.collegeId,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      /// ---------- BRANCH ----------
                      if (branches.isNotEmpty)
                        DropdownButtonFormField<Branch>(
                          decoration: const InputDecoration(
                            labelText: 'Select Branch',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedBranch,
                          items: branches
                              .where((b) =>
                          b.courseId ==
                              selectedCourse?.courseId)
                              .map(
                                (b) => DropdownMenuItem(
                              value: b,
                              child: Text(b.branchName),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBranch = value;
                              selectedBatch = null;
                            });

                            context.read<SectionBloc>().add(
                              LoadAllBatchesEvent(
                                branchId: value!.branchId,
                                collegeId: widget.collegeId,
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 16),

                      /// ---------- BATCH ----------
                      if (batches.isNotEmpty)
                        DropdownButtonFormField<AcademicBatch>(
                          decoration: const InputDecoration(
                            labelText: 'Select Batch',
                            border: OutlineInputBorder(),
                          ),
                          value: selectedBatch,
                          items: batches
                              .map(
                                (b) => DropdownMenuItem(
                              value: b,
                              child: Text(b.batchId),
                            ),
                          )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedBatch = value),
                        ),

                      const SizedBox(height: 20),

                      /// ---------- LOAD SECTIONS ----------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedBatch == null
                              ? null
                              : () {
                            context.read<SectionBloc>().add(
                              LoadSectionsForBatchEvent(
                                branchId:
                                selectedBranch!.branchId,
                                collegeId: widget.collegeId,
                                batchId:
                                selectedBatch!.batchId,
                              ),
                            );
                          },
                          child: const Text('Load Sections'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ---------- SECTIONS ----------
                      if (sections.isEmpty)
                        const Center(
                          child: Text('No sections found'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: sections.length,
                          itemBuilder: (context, index) {
                            return _sectionCard(sections[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ---------------- SECTION CARD ----------------
  Widget _sectionCard(Section section) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(section.sectionName),
        subtitle:
        Text('Semester: ${section.currentSemesterNumber}'),
        trailing: ElevatedButton(
          onPressed: () => _showPromotionDialog(section),
          child: const Text('Promote'),
        ),
      ),
    );
  }

  /// ---------------- CONFIRM DIALOG ----------------
  void _showPromotionDialog(Section section) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Promotion'),
        content: Text(
          'Promote ${section.sectionName} '
              'from Semester ${section.currentSemesterNumber} '
              'to Semester ${section.currentSemesterNumber + 1}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SectionBloc>().add(
                PromoteSectionEvent(
                  collegeId: widget.collegeId,
                  sectionId: section.sectionId,
                  currentSemId:
                  section.currentSemesterId,
                  currentSemNo:
                  section.currentSemesterNumber,
                ),
              );
            },
            child: const Text('Promote'),
          ),
        ],
      ),
    );
  }
}
