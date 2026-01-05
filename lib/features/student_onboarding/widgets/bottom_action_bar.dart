import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show TextButton, Navigator, StatelessWidget, BuildContext, Widget, EdgeInsets, Text, SizedBox, InputDecoration, FilledButton, Expanded, Row, Padding, SafeArea, TextEditingController, OutlineInputBorder, TextField, AlertDialog, showDialog, Colors;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/student.dart';
import '../bloc/student_verification_bloc.dart';
import '../bloc/student_verification_event.dart';

class BottomActionBar extends StatelessWidget {
  final String collegeId;
  final Student student;

  const BottomActionBar({
    super.key,
    required this.collegeId,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: () => _showRejectDialog(context),
                child: const Text('Reject',style: TextStyle(color:Colors.red),),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => _showVerifyConfirmDialog(context),
                child: const Text('Mark Verified'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- VERIFY CONFIRMATION ----------------
  void _showVerifyConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Verification'),
          content: const Text(
            'Are you sure all documents are verified and correct?\n'
                'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<StudentOnboardingBloc>().add(
                  MarkStudentVerifiedEvent(
                    collegeId: collegeId,
                    studentId: student.id,
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  /// ---------------- REJECT DIALOG ----------------
  void _showRejectDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reject Student Verification'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter rejection reason',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final reason = controller.text.trim();
                if (reason.isEmpty) return;

                Navigator.pop(dialogContext);

                context.read<StudentOnboardingBloc>().add(
                  MarkStudentVerificationFailedEvent(
                    collegeId: collegeId,
                    studentId: student.id,
                    message: reason,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
