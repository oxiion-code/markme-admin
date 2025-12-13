import 'package:flutter/material.dart';

class EligibilitySection extends StatelessWidget {
  final TextEditingController cgpaCtrl;
  final TextEditingController backlogCtrl;

  const EligibilitySection({
    super.key,
    required this.cgpaCtrl,
    required this.backlogCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: cgpaCtrl,
              decoration: const InputDecoration(labelText: 'Min CGPA'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: backlogCtrl,
              decoration: const InputDecoration(labelText: 'Max Backlogs'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }
}
