import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplicationsTab extends StatefulWidget {
  const ApplicationsTab({super.key});

  @override
  State<ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends State<ApplicationsTab> {
  final List<_Application> _applications = [
    _Application(company: 'Google', role: 'SDE', status: 'Applied'),
    _Application(company: 'Microsoft', role: 'Intern', status: 'Interview'),
  ];

  Future<void> _showAddApplicationDialog() async {
    final companyController = TextEditingController();
    final roleController = TextEditingController();
    String status = 'Applied';

    final result = await showDialog<_Application>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Application'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role / Position',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Applied',
                      child: Text('Applied'),
                    ),
                    DropdownMenuItem(
                      value: 'Shortlisted',
                      child: Text('Shortlisted'),
                    ),
                    DropdownMenuItem(
                      value: 'Interview',
                      child: Text('Interview'),
                    ),
                    DropdownMenuItem(
                      value: 'Offer',
                      child: Text('Offer'),
                    ),
                    DropdownMenuItem(
                      value: 'Rejected',
                      child: Text('Rejected'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      status = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (companyController.text.trim().isNotEmpty &&
                    roleController.text.trim().isNotEmpty) {
                  Navigator.pop(
                    context,
                    _Application(
                      company: companyController.text.trim(),
                      role: roleController.text.trim(),
                      status: status,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() => _applications.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80, top: 8),
        itemCount: _applications.length,
        itemBuilder: (context, index) {
          final app = _applications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(app.company[0]),
                ),
                title: Text(app.company),
                subtitle: Text('${app.role} • ${app.status}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: navigate to application details
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Application {
  final String company;
  final String role;
  final String status;

  _Application({
    required this.company,
    required this.role,
    required this.status,
  });
}
