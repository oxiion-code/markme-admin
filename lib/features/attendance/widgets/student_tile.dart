import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/student_with_status.dart';

class StudentTile extends StatelessWidget {
  final StudentWithStatus studentWithStatus;
  const StudentTile({super.key, required this.studentWithStatus});

  @override
  Widget build(BuildContext context) {
    final student = studentWithStatus.student;

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: student.profilePhotoUrl,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
            placeholder: (context, url) => const Center(
              child: Icon(Icons.person, color: Colors.grey),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
          ),
        ),
      ),
      title: Text(
        student.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Roll No: ${student.rollNo}',
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      trailing: Icon(
        studentWithStatus.isPresent ? Icons.check_circle : Icons.cancel,
        color: studentWithStatus.isPresent ? Colors.green : Colors.red,
      ),
    );
  }
}
