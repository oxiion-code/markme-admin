
import 'package:flutter/material.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';


class BranchContainer extends StatelessWidget {
  final Branch branch;
  final VoidCallback onEdit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const BranchContainer({
    super.key,
    required this.branch,
    required this.onEdit,
    required this.onDelete,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.85),
                Colors.lightBlue.shade100.withValues(alpha: 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF0D47A1), // Deep blue border
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Branch Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/images/branch_icon.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Branch Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch.branchName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1), // Deep blue text
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ID: ${branch.branchId}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1565C0), // Medium blue text
                            ),
                          ),
                          Text(
                            "Course ID: ${branch.courseId}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Edit & Delete Buttons (top-right corner)
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF0D47A1)),
                      tooltip: 'Edit',
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: 'Delete',
                      onPressed: onDelete,
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
