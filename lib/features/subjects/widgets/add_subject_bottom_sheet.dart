import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_textbox.dart';
import '../../academic_structure/models/branch.dart';
import '../bloc/subject_bloc.dart';
import '../bloc/subject_event.dart';
import '../bloc/subject_state.dart';
import '../models/subject.dart';

class AddSubjectBottomSheet extends StatefulWidget {
  final List<Branch> branches;
  final Function(Subject) onAddSubjectClick;
  final String collegeId;

  const AddSubjectBottomSheet({
    super.key,
    required this.branches,
    required this.onAddSubjectClick,
    required this.collegeId,
  });

  @override
  State<AddSubjectBottomSheet> createState() =>
      _AddSubjectBottomSheetState();
}

class _AddSubjectBottomSheetState extends State<AddSubjectBottomSheet> {
  String? selectedBranchId;
  String? selectedBatchId;
  String? selectedType;

  final nameController = TextEditingController();
  final subjectCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Add Subject",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),

            /// ---------- BRANCH DROPDOWN ----------
            DropdownButtonFormField<String>(
              value: selectedBranchId,
              isExpanded: true,
              hint: const Text('Select Branch'),
              items: widget.branches.map((branch) {
                return DropdownMenuItem(
                  value: branch.branchId,
                  child: Text(branch.branchName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBranchId = value;
                  selectedBatchId = null;
                });

                context.read<SubjectBloc>().add(
                  LoadAllBatches(
                    collegeId: widget.collegeId,
                    branchId: value!,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            /// ---------- BATCH DROPDOWN (BLOC) ----------
            BlocBuilder<SubjectBloc, SubjectState>(
              builder: (context, state) {
                if (state is BatchesLoaded) {
                  return DropdownButtonFormField<String>(
                    value: selectedBatchId,
                    isExpanded: true,
                    hint: const Text("Select Batch"),
                    items: state.batches.map((batch) {
                      return DropdownMenuItem(
                        value: batch.batchId,
                        child: Text(batch.batchId),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBatchId = value;
                      });
                    },
                  );
                }

                if (state is SubjectLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),

            const SizedBox(height: 16),

            CustomTextbox(
              controller: nameController,
              icon: Icons.book_outlined,
              hint: 'Enter subject name',
            ),

            const SizedBox(height: 16),

            CustomTextbox(
              controller: subjectCodeController,
              icon: Icons.code,
              hint: 'Enter subject code',
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedType,
              hint: const Text("Select Subject Type"),
              items: const [
                DropdownMenuItem(value: "Theory", child: Text("Theory")),
                DropdownMenuItem(value: "Practical", child: Text("Practical")),
              ],
              onChanged: (value) {
                setState(() => selectedType = value);
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                child: const Text("Add Subject"),
                onPressed: () {
                  if (selectedBranchId == null ||
                      selectedBatchId == null ||
                      selectedType == null ||
                      nameController.text.isEmpty ||
                      subjectCodeController.text.isEmpty) {
                    AppUtils.showDialogMessage(
                      context,
                      "Please fill all fields",
                      "Missing Information",
                    );
                    return;
                  }

                  widget.onAddSubjectClick(
                    Subject(
                      subjectId:
                      "${selectedBranchId}_${selectedBatchId}_${nameController.text}",
                      subjectName: nameController.text.trim(),
                      branchId: selectedBranchId!,
                      batchId: selectedBatchId!,
                      subjectCode: subjectCodeController.text.trim(),
                      subjectType: selectedType!,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
