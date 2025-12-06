import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

import '../../models/course.dart';

class AddBranchBottomSheet extends StatefulWidget {
  final TextEditingController branchIdController;
  final TextEditingController branchNameController;
  final List<Course> courses;
  final Function(Branch) onAddClick;

  const AddBranchBottomSheet({
    super.key,
    required this.branchIdController,
    required this.branchNameController,
    required this.onAddClick,
    required this.courses,
  });

  @override
  State<AddBranchBottomSheet> createState() => _AddBranchBottomSheetState();
}

class _AddBranchBottomSheetState extends State<AddBranchBottomSheet> {
  String? selectedCourseId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
        
            Text(
              'Add  Branch',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCourseId,
              hint: Text('Select a Course'),
              items: widget.courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course.courseId,
                  child: Text(course.courseName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourseId = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextbox(
              controller: widget.branchIdController,
              icon: Icons.flag_circle,
              hint: 'Enter branch id',
            ),
            const SizedBox(height: 10),
            CustomTextbox(
              controller: widget.branchNameController,
              icon: Icons.abc_outlined,
              hint: 'Enter branch name',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (selectedCourseId != null &&
                    widget.branchIdController.text.trim().isNotEmpty &&
                    widget.branchNameController.text.isNotEmpty) {
                  widget.onAddClick(
                    Branch(
                      branchId: widget.branchIdController.text.trim(),
                      courseId: selectedCourseId!,
                      branchName: widget.branchNameController.text.trim(),
                    ),
                  );
                } else{
                  AppUtils.showDialogMessage(context, "Please select a course and fill all the fields", "Sorry!!!");
                }
              },
              child: Text("Add Branch"),
            ),
          ],
        ),
      ),
    );
  }
}
