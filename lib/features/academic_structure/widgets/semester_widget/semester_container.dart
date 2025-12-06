import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

class SemesterContainer extends StatelessWidget {
  final Semester semester;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SemesterContainer({
    super.key,
    required this.semester,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 12,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF0D47A1), // Deep Blue border
              width: 2,
            ),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.85),
                const Color(0xFFBBDEFB).withValues(alpha: 0.9), // Light Blue
                Colors.white.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withValues(alpha: 0.92),
                      child: Image.asset(
                        "assets/images/semester_icon.png",
                        height: 28,
                        width: 28,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Semester ${semester.semesterNumber}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "ID: ${semester.semesterId.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[700]?.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_rounded,
                              color: Color(0xFF0D47A1)),
                          tooltip: 'Edit',
                          onPressed: onEdit,
                          splashRadius: 26,
                          splashColor: Colors.blueAccent.withOpacity(0.2),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever_rounded,
                              color: Colors.redAccent),
                          tooltip: 'Delete',
                          onPressed: onDelete,
                          splashRadius: 26,
                          splashColor: Colors.lightBlue.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
