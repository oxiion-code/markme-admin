import 'package:flutter/material.dart';

import '../models/teacher.dart';

// Replace this with your actual Teacher model

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final VoidCallback onDelete;

  const TeacherCard({
    super.key,
    required this.teacher,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.deepPurple),
        title: Text(
          teacher.teacherName ,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("ID: ${teacher.teacherId}\nBranch: ${teacher.branchId.toUpperCase()}"),
        trailing: Wrap(
          spacing: 12,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Delete",
            ),
          ],
        ),
      ),
    );
  }
}
