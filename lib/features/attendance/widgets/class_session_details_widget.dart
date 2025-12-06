import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../classes/models/class_session.dart';

class ClassSessionDetailsWidget extends StatelessWidget {
  final ClassSession session;
  const ClassSessionDetailsWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    final Color primaryColor = Colors.blueAccent;
    final Color secondaryColor = Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject and section row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    session.subjectName,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    session.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor:
                  session.status.toLowerCase() == "completed"
                      ? Colors.green
                      : Colors.orangeAccent,
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    session.teacherName,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.meeting_room_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Room: ${session.roomName}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                Text(
                  'Section: ${session.sectionName}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(dateFormatter.format(session.date),
                      style:
                      const TextStyle(fontSize: 14, color: Colors.black87)),
                  const SizedBox(width: 20),
                  const Icon(Icons.access_time_outlined,
                      size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(
                    '${timeFormatter.format(session.startTime)} - ${timeFormatter.format(session.endTime)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Text(
              'Group: ${session.group} | Semester: ${session.semesterNo}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
