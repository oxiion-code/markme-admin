import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

class AddBatchBottomSheet extends StatefulWidget {
  final List<Branch> branches;
  final Function(AcademicBatch) onAddBatchClick;

 const  AddBatchBottomSheet({super.key, required this.onAddBatchClick,required this.branches});

  @override
  State<AddBatchBottomSheet> createState() => _AddBatchBottomSheetState();
}

class _AddBatchBottomSheetState extends State<AddBatchBottomSheet> {
  final TextEditingController startYearController = TextEditingController();

  final TextEditingController endYearController = TextEditingController();

  String? selectedBranchId;

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
          children: [
            Text("Add a batch",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),),
            const SizedBox(height: 15),
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
            CustomTextbox(
              controller: startYearController,
              icon: Icons.date_range,
              hint: 'start year, eg:2021',
            ),
            const SizedBox(height: 16),
            CustomTextbox(
              controller: endYearController,
              icon: Icons.close_fullscreen_sharp,
              hint: 'end year, eg:2024',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final startYear = startYearController.text.trim();
                final endYear = endYearController.text.trim();
                if (startYear.isNotEmpty && endYear.isNotEmpty) {
                  widget.onAddBatchClick(
                    AcademicBatch(
                      batchId:"${selectedBranchId}_${startYear}_$endYear",
                      startYear: startYear,
                      endYear: endYear,
                      branchId: selectedBranchId!
                    ),
                  );
                } else {
                  AppUtils.showDialogMessage(
                    context,
                    "Enter starting and ending year",
                    "Sorry!!!",
                  );
                }
              },
              child: Text("Add Batch"),
            ),
          ],
        ),
      ),
    );
  }
}
