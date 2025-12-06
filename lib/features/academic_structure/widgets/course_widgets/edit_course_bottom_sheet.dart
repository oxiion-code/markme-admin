import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';

class EditCourseBottomSheet extends StatefulWidget {
  final Course course;
  final Function(Course course) onSaveEdit;
  const EditCourseBottomSheet({
    super.key,
    required this.onSaveEdit,
    required this.course,
  });

  @override
  State<EditCourseBottomSheet> createState() => _EditCourseBottomSheetState();
}

class _EditCourseBottomSheetState extends State<EditCourseBottomSheet> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController=TextEditingController(text: widget.course.courseName);
    super.initState();
  }

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
          Text("Edit Course ${widget.course.courseId}"),
          const SizedBox(height: 20),
          CustomTextbox(
            controller: textEditingController,
            icon: Icons.abc,
            hint: 'Edit course name',
          ),
          const SizedBox(height: 20),
         ElevatedButton(onPressed: (){
           if(textEditingController.text.trim().isNotEmpty){
             final name=textEditingController.text.trim();
             widget.onSaveEdit(Course(courseId: widget.course.courseId, courseName: name));
             context.pop();
           }
         }, child: Text('Save Changes'))
        ],
      ),
    );
  }
}
