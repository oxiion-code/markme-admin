import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_state.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';
import 'package:markme_admin/features/teacher/models/teacher.dart';

import '../../../onboarding/cubit/admin_user_cubit.dart';

class AddSectionBottomSheet extends StatefulWidget {
  final List<Branch> branches;
  final Function(Section) onAddSectionClick;

  const AddSectionBottomSheet({
    super.key,
    required this.branches,
    required this.onAddSectionClick,
  });

  @override
  State<AddSectionBottomSheet> createState() => _AddSectionBottomSheetState();
}

class _AddSectionBottomSheetState extends State<AddSectionBottomSheet> {
  String? selectedBatchId;
  String? selectedBranchId;
  String? selectedCourseId;

  String? selectedHodId;
  String? selectedProctorId;

  List<AcademicBatch> loadedBatches = [];
  List<Teacher> loadedTeachers = [];


  final TextEditingController nameController = TextEditingController();
  final TextEditingController defaultRoomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final collegeId=context.read<AdminUserCubit>().state!.collegeId;
    return BlocListener<SectionBloc, SectionState>(
      listener: (context, state) {
        if (state is BatchesLoaded) {
          setState(() {
            loadedBatches = state.batches;
            selectedBatchId = null;
          });
        }
        if (state is TeachersLoadedForSection) {
          setState(() {
            loadedTeachers = state.teachers;
            selectedHodId = null;
            selectedProctorId = null;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add section"),
              const SizedBox(height: 16),

              DropdownButton<String>(
                isExpanded: true,
                value: selectedBranchId,
                hint: Text('Select a branch'),
                items: widget.branches.map((branch) {
                  return DropdownMenuItem<String>(
                    value: branch.branchId,
                    child: Text(branch.branchName),
                  );
                }).toList(),
                onChanged: (value) {
                  final selectedBranch = widget.branches.firstWhere(
                    (branch) => branch.branchId == value,
                  );
                  setState(() {
                    selectedBranchId = value!;
                    selectedCourseId = selectedBranch.courseId;
                    loadedBatches.clear();
                    loadedTeachers.clear();
                  });
                  context.read<SectionBloc>().add(
                    LoadAllBatchesEvent(branchId: selectedBranchId!, collegeId: collegeId),
                  );
                },
              ),
              const SizedBox(height: 16),

              DropdownButton<String>(
                isExpanded: true,
                value: selectedBatchId,
                hint: Text('Select a Batch'),
                items: loadedBatches.map((batch) {
                  return DropdownMenuItem<String>(
                    value: batch.batchId,
                    child: Text(
                      batch.batchId.split("_").join("-").toUpperCase(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBatchId = value!;
                  });
                  context.read<SectionBloc>().add(
                    LoadTeachersForSection(branchId: selectedBranchId!,collegeId: collegeId),
                  );
                },
              ),
              const SizedBox(height: 16),
              if (loadedTeachers.isNotEmpty)
                DropdownButton(
                  isExpanded: true,
                  value: selectedHodId,
                  hint: Text("Select HOD"),
                  items: loadedTeachers.map((t) {
                    return DropdownMenuItem<String>(
                      value: t.teacherId,
                      child: Text(t.teacherName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHodId = value;
                    });
                  },
                ),

              const SizedBox(height: 16),
              if (loadedTeachers.isNotEmpty)
                DropdownButton(
                  isExpanded: true,
                  value: selectedProctorId,
                  hint: Text("Select HOD"),
                  items: loadedTeachers.map((t) {
                    return DropdownMenuItem<String>(
                      value: t.teacherId,
                      child: Text(t.teacherName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProctorId = value;
                    });
                  },
                ),

              CustomTextbox(
                controller: nameController,
                icon: Icons.abc_outlined,
                hint: 'eg:section k, CSE I',
              ),
              const SizedBox(height: 16),
              CustomTextbox(
                controller: defaultRoomController,
                icon: Icons.abc_outlined,
                hint: 'eg: W103, M204',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final defaultRoom = defaultRoomController.text.trim();
                  if (selectedBranchId != null &&
                      selectedBatchId != null &&
                      selectedCourseId != null &&
                      selectedHodId != null &&
                      selectedProctorId != null &&
                      defaultRoom.isNotEmpty &&
                      name.isNotEmpty) {
                    final hodName = loadedTeachers
                        .firstWhere((t) => t.teacherId == selectedHodId)
                        .teacherName;
                    final proctorName = loadedTeachers
                        .firstWhere((p) => p.teacherId == selectedProctorId)
                        .teacherName;
                    widget.onAddSectionClick(
                      Section(
                        sectionId: "${selectedBatchId!}_$name",
                        sectionName: name,
                        batchId: selectedBatchId!,
                        branchId: selectedBranchId!,
                        studentIds: [],
                        courseId: selectedCourseId!,
                        defaultRoom: defaultRoom,
                        currentSemesterNumber: 1,
                        currentSemesterId: "${selectedBranchId!}_sem_01",
                        hodId: selectedHodId,
                        proctorId: selectedProctorId,
                        hodName: hodName,
                        proctorName: proctorName,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    AppUtils.showDialogMessage(
                      context,
                      "Select all fields and enter values",
                      "Sorry...",
                    );
                  }
                },
                child: Text("Add section"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
