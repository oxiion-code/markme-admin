import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

import '../../../academic_structure/models/academic_batch.dart';
import '../../../academic_structure/models/branch.dart';
import '../../../academic_structure/models/course.dart';

import '../../blocs/session/session_bloc.dart';
import '../../blocs/session/session_state.dart';
import '../../blocs/session/session_event.dart';
import '../../models/company/company_details.dart';
import '../../models/session/eligibility.dart';
import '../../models/session/placement_session.dart';

import '../../widgets/add_placement_session/company_info_section.dart';
import '../../widgets/add_placement_session/session_details_section.dart';
import '../../widgets/add_placement_session/eligibility_section.dart';
import '../../widgets/add_placement_session/schedule_section.dart';

class AddPlacementSessionScreen extends StatefulWidget {
  final CompanyDetails companyDetails;

  const AddPlacementSessionScreen({
    super.key,
    required this.companyDetails,
  });

  @override
  State<AddPlacementSessionScreen> createState() =>
      _AddPlacementSessionScreenState();
}

class _AddPlacementSessionScreenState
    extends State<AddPlacementSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final sessionNameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();
  final cgpaCtrl = TextEditingController();
  final backlogCtrl = TextEditingController();

  String driveType = 'Placement';
  String status = 'upcoming';
  String? jobRole;
  DateTime? startDate;
  DateTime? endDate;

  Course? selectedCourse;

  List<Course> loadedCourses = [];
  List<Branch> loadedBranches = [];

  /// 🔥 CORE STRUCTURES (ONLY BATCH IDS)
  final Map<String, List<AcademicBatch>> branchBatchesMap = {};
  final Map<String, List<String>> selectedBatchesPerBranch = {};

  bool _isLoadingShown = false;

  @override
  void initState() {
    super.initState();
    context.read<PlacementSessionBloc>().add(
      LoadCoursesForPlacementSession(
        collegeId: widget.companyDetails.collegeId,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (startDate == null || endDate == null) return;

    final allSelectedBatchIds = selectedBatchesPerBranch.values
        .expand((e) => e)
        .toSet()
        .toList();

    if (allSelectedBatchIds.isEmpty) {
      AppUtils.showCustomSnackBar(context, "Select at least one batch");
      return;
    }

    /// ✅ ELIGIBILITY WITH ONLY BATCH IDs
    final eligibility = Eligibility(
      batches: allSelectedBatchIds, // ✅ ONLY THIS
      minCgpa: double.parse(cgpaCtrl.text),
      maxBacklogs: int.parse(backlogCtrl.text),
    );

    final now = DateTime.now();

    final session = PlacementSession(
      sessionId: now.microsecondsSinceEpoch.toString(),
      sessionName: sessionNameCtrl.text.trim(),
      companyId: widget.companyDetails.company.companyId,
      companyName: widget.companyDetails.company.name,
      role: jobRole!,
      driveType: driveType,
      description: descriptionCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      eligibility: eligibility,
      requiredSkills:
      skillsCtrl.text.split(',').map((e) => e.trim()).toList(),
      startDate: startDate!,
      endDate: endDate!,
      createdAt: now,
      status: status,
      formId: '',
      collegeId: widget.companyDetails.collegeId,
    );

    context.read<PlacementSessionBloc>().add(
      AddPlacementSession(session),
    );
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.companyDetails.company;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Placement Session')),
      body: BlocListener<PlacementSessionBloc, PlacementSessionState>(
        listener: (context, state) {
          if (state is PlacementSessionLoading) {
            if (!_isLoadingShown) {
              _isLoadingShown = true;
              AppUtils.showCustomLoading(context);
            }
          } else if (_isLoadingShown) {
            _isLoadingShown = false;
            context.pop();
          }

          if (state is CoursesLoadedForSession) {
            setState(() => loadedCourses = state.loadedCourses);
          }

          if (state is BranchesLoadedForSession) {
            setState(() => loadedBranches = state.loadedBranches);
          }

          if (state is BatchesLoadedForSession) {
            setState(() {
              branchBatchesMap[state.branchId] = state.loadedBatches;
              selectedBatchesPerBranch.putIfAbsent(state.branchId, () => []);
            });
          }

          if (state is PlacementSessionAdded) {
            AppUtils.showCustomSnackBar(context, "Session created");
            context.pop();
          }

          if (state is PlacementSessionFailure) {
            AppUtils.showCustomSnackBar(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompanyInfoSection(company: company),
                const SizedBox(height: 12),

                SessionDetailsSection(
                  company: company,
                  sessionNameCtrl: sessionNameCtrl,
                  descriptionCtrl: descriptionCtrl,
                  locationCtrl: locationCtrl,
                  skillsCtrl: skillsCtrl,
                  driveType: driveType,
                  status: status,
                  jobRole: jobRole,
                  onDriveTypeChanged: (v) => setState(() => driveType = v),
                  onStatusChanged: (v) => setState(() => status = v),
                  onJobRoleChanged: (v) => setState(() => jobRole = v),
                ),

                const SizedBox(height: 16),

                /// COURSE
                DropdownButtonFormField<Course>(
                  decoration: const InputDecoration(
                    labelText: 'Select Course',
                    border: OutlineInputBorder(),
                  ),
                  items: loadedCourses
                      .map(
                        (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.courseName),
                    ),
                  )
                      .toList(),
                  onChanged: (course) {
                    selectedCourse = course;
                    context.read<PlacementSessionBloc>().add(
                      LoadBranchesForPlacementSession(
                        collegeId: widget.companyDetails.collegeId,
                        courseId: course!.courseId,
                      ),
                    );
                  },
                  validator: (v) =>
                  v == null ? 'Please select course' : null,
                ),

                const SizedBox(height: 12),

                /// BRANCH → BATCH TREE (UI ONLY)
                ...loadedBranches.map((branch) {
                  final batches = branchBatchesMap[branch.branchId] ?? [];
                  final selected =
                      selectedBatchesPerBranch[branch.branchId] ?? [];

                  return Card(
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(branch.branchName),
                          value: batches.isNotEmpty,
                          onChanged: (v) {
                            if (v == true &&
                                !branchBatchesMap
                                    .containsKey(branch.branchId)) {
                              context.read<PlacementSessionBloc>().add(
                                LoadBatchesForPlacementSession(
                                  collegeId:
                                  widget.companyDetails.collegeId,
                                  branchId: branch.branchId,
                                ),
                              );
                            }
                          },
                        ),

                        if (batches.isNotEmpty) ...[
                          CheckboxListTile(
                            title: const Text("Select All Batches"),
                            value: selected.length == batches.length,
                            onChanged: (v) {
                              setState(() {
                                selectedBatchesPerBranch[branch.branchId] =
                                v!
                                    ? batches
                                    .map((e) => e.batchId)
                                    .toList()
                                    : [];
                              });
                            },
                          ),
                          ...batches.map(
                                (batch) => CheckboxListTile(
                              title: Text(batch.batchId.toUpperCase()),
                              value: selected.contains(batch.batchId),
                              onChanged: (v) {
                                setState(() {
                                  v!
                                      ? selected.add(batch.batchId)
                                      : selected.remove(batch.batchId);
                                });
                              },
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),
                _buildSelectedEligibilityUI(),
                const SizedBox(height: 16),

                EligibilitySection(
                  cgpaCtrl: cgpaCtrl,
                  backlogCtrl: backlogCtrl,
                ),

                const SizedBox(height: 16),

                ScheduleSection(
                  startDate: startDate,
                  endDate: endDate,
                  onStartDate: (d) => setState(() => startDate = d),
                  onEndDate: (d) => setState(() => endDate = d),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Create Session'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 CHIPS (BATCH ONLY)
  Widget _buildSelectedEligibilityUI() {
    final allBatches =
    selectedBatchesPerBranch.values.expand((e) => e).toList();

    if (allBatches.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selected Batches",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: allBatches.map((batchId) {
            return Chip(
              label: Text(batchId.toUpperCase()),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  for (final entry in selectedBatchesPerBranch.entries) {
                    entry.value.remove(batchId);
                  }
                  selectedBatchesPerBranch
                      .removeWhere((_, v) => v.isEmpty);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
