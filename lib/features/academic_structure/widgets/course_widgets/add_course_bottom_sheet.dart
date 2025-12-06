import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';

class AddCourseBottomSheet extends StatefulWidget {
  final Function(Course course) onAddClicked;
  const AddCourseBottomSheet({super.key,required this.onAddClicked});


  @override
  State<AddCourseBottomSheet> createState() => _AddCourseBottomSheetState();
}

class _AddCourseBottomSheetState extends State<AddCourseBottomSheet> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add Course",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            "*Give a unique course id and course name",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppColors.primaryLight.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextbox(
            controller: _courseCodeController,
            icon: Icons.golf_course,
            hint: 'Course Id',
          ),
          const SizedBox(height: 10),
          CustomTextbox(
            controller: _courseNameController,
            icon: Icons.abc,
            hint: 'Course Name',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final name = _courseNameController.text.trim();
              final code = _courseCodeController.text.trim();
              if (name.isNotEmpty && code.isNotEmpty) {
                // Save to Firebase or local list here
                Navigator.of(context).pop();
                widget.onAddClicked(Course(courseId: code, courseName: name));
              }
            },
            child: const Text('Add Course'),
          ),
        ],
      ),
    );
  }
}
