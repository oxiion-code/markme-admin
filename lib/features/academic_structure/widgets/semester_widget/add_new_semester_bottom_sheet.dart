import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import '../../models/semester.dart';

class AddSemesterBottomSheet extends StatefulWidget {
  final List<Course> courses;
  final Function(Semester) addSemester;

  const AddSemesterBottomSheet({
    super.key,
    required this.courses,
    required this.addSemester,
  });

  @override
  State<AddSemesterBottomSheet> createState() => _AddSemesterBottomSheetState();
}

class _AddSemesterBottomSheetState extends State<AddSemesterBottomSheet> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  String? selectedCourse;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Add New Semester',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // Course dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Course',
              ),
              value: selectedCourse,
              items: widget.courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course.courseId,
                  child: Text(course.courseName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Semester ID
            CustomTextbox(
              controller: idController,
              icon: Icons.flag,
              hint: 'Enter semester ID',
            ),
            const SizedBox(height: 14),

            // Semester number
            CustomTextbox(
              controller: numberController,
              icon: Icons.numbers,
              hint: 'Enter semester number (e.g., 1)',
            ),
            const SizedBox(height: 16),

            // Start date picker
            InkWell(
              onTap: () => _pickDate(isStart: true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      startDate != null
                          ? "Start Date: ${dateFormat.format(startDate!)}"
                          : "Select start date",
                      style: TextStyle(
                        fontSize: 14,
                        color: startDate != null ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // End date picker
            InkWell(
              onTap: () => _pickDate(isStart: false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      endDate != null
                          ? "End Date: ${dateFormat.format(endDate!)}"
                          : "Select end date",
                      style: TextStyle(
                        fontSize: 14,
                        color: endDate != null ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Submit button
            ElevatedButton(
              onPressed: () {
                if (selectedCourse != null &&
                    idController.text.trim().isNotEmpty &&
                    numberController.text.trim().isNotEmpty &&
                    startDate != null &&
                    endDate != null) {
                  widget.addSemester(
                    Semester(
                      courseId: selectedCourse!,
                      semesterId:
                      "${selectedCourse!}_${idController.text.trim()}",
                      semesterNumber:
                      int.parse(numberController.text.trim()),
                      startDate: startDate!.millisecondsSinceEpoch,
                      endDate: endDate!.millisecondsSinceEpoch,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  AppUtils.showDialogMessage(
                    context,
                    "Please fill all the fields and select dates",
                    "Missing Fields!",
                  );
                }
              },
              child: const Text('Add Semester'),
            ),
          ],
        ),
      ),
    );
  }
}
