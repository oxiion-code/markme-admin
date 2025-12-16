import 'package:flutter/material.dart';
import 'empty_state.dart';

class JobRolesChips extends StatelessWidget {
  final List<String> jobRoles;
  final bool isEditable;
  final TextEditingController controller;
  final void Function(String role) onAdd;
  final void Function(int index) onDelete;

  const JobRolesChips({
    super.key,
    required this.jobRoles,
    required this.isEditable,
    required this.controller,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isEditable) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Add job role",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    onAdd(controller.text.trim());
                    controller.clear();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        if (jobRoles.isEmpty)
          EmptyState(
            icon: Icons.work_outline,
            label: "No job roles added",
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: jobRoles.asMap().entries.map((entry) {
              final index = entry.key;
              final role = entry.value;

              return Chip(
                avatar: const Icon(Icons.work, size: 16, color: Colors.blue),
                label: Text(
                  role,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.blue.withOpacity(0.12),
                deleteIcon: isEditable
                    ? const Icon(Icons.close, size: 16)
                    : null,
                onDeleted: isEditable ? () => onDelete(index) : null,
              );
            }).toList(),
          ),
      ],
    );
  }
}
