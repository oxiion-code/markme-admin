import 'package:flutter/material.dart';

import '../../models/company/company.dart';


class SessionDetailsSection extends StatelessWidget {
  final Company company;
  final TextEditingController sessionNameCtrl;
  final TextEditingController descriptionCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController skillsCtrl;

  final String driveType;
  final String status;
  final String? jobRole;

  final ValueChanged<String> onDriveTypeChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String?> onJobRoleChanged;

  const SessionDetailsSection({
    super.key,
    required this.company,
    required this.sessionNameCtrl,
    required this.descriptionCtrl,
    required this.locationCtrl,
    required this.skillsCtrl,
    required this.driveType,
    required this.status,
    required this.jobRole,
    required this.onDriveTypeChanged,
    required this.onStatusChanged,
    required this.onJobRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: sessionNameCtrl,
              decoration: const InputDecoration(labelText: 'Session Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: jobRole,
              items: company.jobRoles
                  .map((r) =>
                  DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: onJobRoleChanged,
              decoration: const InputDecoration(labelText: 'Job Role'),
              validator: (v) => v == null ? 'Select role' : null,
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: driveType,
              items: const [
                DropdownMenuItem(value: 'Placement', child: Text('Placement')),
                DropdownMenuItem(value: 'Internship', child: Text('Internship')),
              ],
              onChanged: (v) => onDriveTypeChanged(v!),
              decoration: const InputDecoration(labelText: 'Drive Type'),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                DropdownMenuItem(value: 'live', child: Text('Live')),
              ],
              onChanged: (v) => onStatusChanged(v!),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
      ),
    );
  }
}
