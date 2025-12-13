import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
class EditBranchBottomSheet extends StatefulWidget {
  final Branch branch;
  final List<Course> courses;
  final Function(Branch) onSaveEdit;

  const EditBranchBottomSheet({
    super.key,
    required this.onSaveEdit,
    required this.branch,
    required this.courses,
  });

  @override
  State<EditBranchBottomSheet> createState() => _EditBranchBottomSheetState();
}

class _EditBranchBottomSheetState extends State<EditBranchBottomSheet> {
  late TextEditingController nameController;
  String? selectedText;

  @override
  void initState() {
    super.initState();
    selectedText = widget.branch.courseId;
    nameController = TextEditingController(text: widget.branch.branchName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Edit Branch",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 10),
          CustomTextbox(
            controller: nameController,
            icon: Icons.abc_outlined,
            hint: "Enter branch name",
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                widget.onSaveEdit(
                  widget.branch.copyWith(
                    branchName: nameController.text.trim(),
                    courseId: selectedText ?? widget.branch.courseId,
                  ),
                );
                Navigator.pop(context);
              } else {
                AppUtils.showDialogMessage(
                  context,
                  "Please enter name and select branch",
                  "Sorry!!!",
                );
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }
}
