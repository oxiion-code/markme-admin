import 'package:flutter/material.dart';

import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_textbox.dart';
import '../../academic_structure/models/branch.dart';

class AddTeacherBottomSheet extends StatefulWidget {
  final List<Branch> branches;
  final Function({
  required String teacherId,
  required String name,
  required String email,
  required String branchId,
  required String phoneNumber
  }) onAddTeacherClick;

  const AddTeacherBottomSheet({
    super.key,
    required this.branches,
    required this.onAddTeacherClick,
  });

  @override
  State<AddTeacherBottomSheet> createState() => _AddTeacherBottomSheetState();
}

class _AddTeacherBottomSheetState extends State<AddTeacherBottomSheet> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController=TextEditingController();
  String? selectedBranchId;

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
                "Add Teacher",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            CustomTextbox(
              controller: idController,
              icon: Icons.badge_outlined,
              hint: 'Enter teacher ID',
            ),
            const SizedBox(height: 16),
            CustomTextbox(
              controller: nameController,
              icon: Icons.person_outline,
              hint: 'Enter teacher name',
            ),
            const SizedBox(height: 16),
            CustomTextbox(
              controller: emailController,
              icon: Icons.email_outlined,
              hint: 'Enter teacher email',
            ),
            const SizedBox(height: 16),
            CustomTextbox(
              controller: phoneNumberController,
              icon: Icons.phone,
              hint: 'Enter teacher phone number',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedBranchId,
                hint: const Text('Select a branch'),
                underline: const SizedBox(),
                items: widget.branches.map((branch) {
                  return DropdownMenuItem<String>(
                    value: branch.branchId,
                    child: Text(branch.branchName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBranchId = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final id = idController.text.trim();
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final phoneNumber= phoneNumberController.text.trim();

                  if (id.isNotEmpty &&
                      name.isNotEmpty &&
                      email.isNotEmpty &&
                      phoneNumber.isNotEmpty&&
                      selectedBranchId != null) {
                    widget.onAddTeacherClick(
                      teacherId: id,
                      name: name,
                      email: email,
                      branchId: selectedBranchId!,
                      phoneNumber: phoneNumber
                    );
                    Navigator.pop(context);
                  } else {
                    AppUtils.showDialogMessage(
                      context,
                      "Please fill all fields",
                      "Validation Error",
                    );
                  }
                },
                child: const Text("Add Teacher"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
