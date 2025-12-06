import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentPermissionScreen extends StatefulWidget {
  const StudentPermissionScreen({super.key});

  @override
  State<StudentPermissionScreen> createState() => _StudentPermissionScreenState();
}

class _StudentPermissionScreenState extends State<StudentPermissionScreen> {
  bool allowReporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Permissions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: allowReporting,
              onChanged: (value) {
                setState(() {
                  allowReporting = value;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? "Student reporting enabled ✅"
                          : "Student reporting disabled ❌",
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              activeThumbColor: Theme.of(context).colorScheme.primary,
              title: Text(
                "Allow Student Reporting",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                "By enabling this option you will allow student for profile registration",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
