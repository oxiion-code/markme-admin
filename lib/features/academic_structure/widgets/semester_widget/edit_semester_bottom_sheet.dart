import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import '../../models/semester.dart';

class EditSemesterBottomSheet extends StatefulWidget {
  final Semester semester;
  final List<Course> courses;
  final Function(Semester) onSaveEdit;

  const EditSemesterBottomSheet({
    super.key,
    required this.semester,
    required this.courses,
    required this.onSaveEdit,
  });

  @override
  State<EditSemesterBottomSheet> createState() =>
      _EditSemesterBottomSheetState();
}

class _EditSemesterBottomSheetState extends State<EditSemesterBottomSheet> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.fromMillisecondsSinceEpoch(widget.semester.startDate);
    endDate = DateTime.fromMillisecondsSinceEpoch(widget.semester.endDate);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate ?? now : endDate ?? now,
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
    final semester = widget.semester;

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
            "Edit Semester Dates",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 20),

          // Display course name (non-editable)
          Text(
            "Course: ${semester.courseId}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            "Semester ID: ${semester.semesterId}",
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 6),
          Text(
            "Semester Number: ${semester.semesterNumber}",
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),

          // Start Date
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
                        : "Select Start Date",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                      startDate != null ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // End Date
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
                        : "Select End Date",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                      endDate != null ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Save Button
          ElevatedButton(
            onPressed: () {
              if (startDate != null && endDate != null) {
                widget.onSaveEdit(
                  semester.copyWith(
                    startDate: startDate!.millisecondsSinceEpoch,
                    endDate: endDate!.millisecondsSinceEpoch,
                  ),
                );
                Navigator.pop(context);
              } else {
                AppUtils.showDialogMessage(
                  context,
                  "Please select both start and end dates",
                  "Incomplete Data",
                );
              }
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}
