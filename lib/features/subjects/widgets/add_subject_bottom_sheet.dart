import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_textbox.dart';
import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../models/subject.dart';

class AddSubjectBottomSheet extends StatefulWidget {
  final List<Branch> branches;
  final List<AcademicBatch> batches;
  final Function(Subject) onAddSubjectClick;

  const AddSubjectBottomSheet({
    super.key,
    required this.branches,
    required this.batches,
    required this.onAddSubjectClick,
  });

  @override
  State<AddSubjectBottomSheet> createState() => _AddSubjectBottomSheetState();
}

class _AddSubjectBottomSheetState extends State<AddSubjectBottomSheet> {
  String? selectedBranchId;
  String? selectedBatchId;
  String? selectedType;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectCodeController = TextEditingController();

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
            Center(
              child: Text(
                "Add Subject",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),

            // Batch Dropdown
            DropdownButton<String>(
              value: selectedBatchId,
              isExpanded: true,
              hint: Text('Select Batch'),
              items: widget.batches.map((batch) {
                return DropdownMenuItem<String>(
                  value: batch.batchId,
                  child: Text(batch.batchId),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBatchId = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Branch Dropdown
            DropdownButton<String>(
              value: selectedBranchId,
              isExpanded: true,
              hint: Text('Select Branch'),
              items: widget.branches.map((branch) {
                return DropdownMenuItem<String>(
                  value: branch.branchId,
                  child: Text(branch.branchName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBranchId = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Subject Name Field
            CustomTextbox(
              controller: nameController,
              icon: Icons.book_outlined,
              hint: 'Enter subject name',
            ),
            const SizedBox(height: 16),

            // Subject Name Field
            CustomTextbox(
              controller: nameController,
              icon: Icons.book_outlined,
              hint: 'Enter subject code',
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              hint: const Text("Select Subject Type"),
              items: const [
                DropdownMenuItem(value: "Theory", child: Text("Theory")),
                DropdownMenuItem(value: "Practical", child: Text("Practical")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Subject Type",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final subjectCode = subjectCodeController.text.trim();
                  if (selectedBranchId != null &&
                      selectedBatchId != null &&
                      name.isNotEmpty &&
                      subjectCode.isNotEmpty &&
                      selectedType != null) {
                    widget.onAddSubjectClick(
                      Subject(
                        subjectId:
                            "${selectedBranchId}_${selectedBatchId}_$name",
                        subjectName: name,
                        branchId: selectedBranchId!,
                        batchId: selectedBatchId!,
                        subjectCode: subjectCode,
                        subjectType: selectedType!,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    AppUtils.showDialogMessage(
                      context,
                      "Please select batch, branch, and enter subject name.",
                      "Missing Information",
                    );
                  }
                },
                child: Text("Add Subject"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
