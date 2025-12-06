import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class ManagePermissionOptionScreen extends StatelessWidget {
  final AdminUser adminUser;
  const ManagePermissionOptionScreen({super.key, required this.adminUser});

  void _onCardTap(BuildContext context, String role) {
    if(role=="Student Permissions"){
      context.push("/studentPermissions",extra: adminUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'title': 'Student Permissions',
        'icon': Icons.school_rounded,
        'color': Colors.blueAccent,
      },
      {
        'title': 'Teacher Permissions',
        'icon': Icons.person_rounded,
        'color': Colors.green,
      },
      {
        'title': 'Admin Permissions',
        'icon': Icons.admin_panel_settings_rounded,
        'color': Colors.deepPurple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Permissions'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return GestureDetector(
            onTap: () => _onCardTap(context, option['title']),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: option['color'].withOpacity(0.15),
                  child: Icon(
                    option['icon'],
                    color: option['color'],
                    size: 28,
                  ),
                ),
                title: Text(
                  option['title'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
