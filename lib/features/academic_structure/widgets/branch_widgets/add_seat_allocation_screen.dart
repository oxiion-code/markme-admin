import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/branch.dart';
import '../../models/branch_seat_allocation.dart';
import '../../bloc/branch_bloc/branch_bloc.dart';
import '../../bloc/branch_bloc/branch_event.dart';
import '../../../onboarding/cubit/admin_user_cubit.dart';

class AddSeatAllocationBottomSheet extends StatefulWidget {
  final Branch branch;
  final BranchSeatAllocation? existingSeat; // ⬅️ NEW

  const AddSeatAllocationBottomSheet({
    super.key,
    required this.branch,
    this.existingSeat, // ⬅️ NEW
  });

  @override
  State<AddSeatAllocationBottomSheet> createState() =>
      _AddSeatAllocationBottomSheetState();
}

class _AddSeatAllocationBottomSheetState
    extends State<AddSeatAllocationBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  String? selectedYear;
  final seatsController = TextEditingController();

  bool get isEditing => widget.existingSeat != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      selectedYear = widget.existingSeat!.year;
      seatsController.text = widget.existingSeat!.totalSeats.toString();
    }
  }

  @override
  void dispose() {
    seatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final collegeId = context.read<AdminUserCubit>().state!.collegeId;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Sheet header ----
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),

                Text(
                  isEditing ? "Edit seat allocation" : "Add seat allocation",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.branch.branchName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // ---- Details box ----
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Academic year",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.75),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Year picker
                      GestureDetector(
                        onTap: isEditing
                            ? null // Year cannot be changed while editing
                            : () => _openYearPicker(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "Year",
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: isEditing
                                  ? null
                                  : const Icon(Icons.calendar_month_rounded),
                            ),
                            controller: TextEditingController(
                              text: selectedYear ?? "",
                            ),
                            validator: (v) =>
                            v == null || v.isEmpty ? "Select a year" : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Total seats",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.75),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Seats input
                      TextFormField(
                        controller: seatsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Enter seat count",
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter seat count";
                          }
                          final value = int.tryParse(v);
                          if (value == null || value <= 0) {
                            return "Enter a valid number";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ---- Submit button ----
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check_rounded),
                    label: Text(isEditing ? "Update allocation" : "Add allocation"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isEditing) {
                          _updateSeatAllocation(collegeId);
                        } else {
                          _addSeatAllocation(collegeId);
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- Year Picker ----
  void _openYearPicker(BuildContext context) {
    if (isEditing) return; // Prevent changing year while editing

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Select year"),
          content: SizedBox(
            width: 320,
            height: 320,
            child: YearPicker(
              firstDate: DateTime(2010),
              lastDate: DateTime(2050),
              selectedDate: selectedYear != null
                  ? DateTime(int.parse(selectedYear!))
                  : DateTime.now(),
              onChanged: (DateTime date) {
                setState(() {
                  selectedYear = date.year.toString();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  // ---- Add ----
  void _addSeatAllocation(String collegeId) {
    final allocation = BranchSeatAllocation(
      allocationId: "${widget.branch.branchId}_${selectedYear!}",
      branchId: widget.branch.branchId,
      courseId: widget.branch.courseId,
      year: selectedYear!,
      totalSeats: int.parse(seatsController.text),
      availableSeats: int.parse(seatsController.text),
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<BranchBloc>().add(
      AddBranchSeatAllocationEvent(
        collegeId: collegeId,
        seatAllocation: allocation,
      ),
    );

    Navigator.pop(context);
  }

  // ---- Update ----
  void _updateSeatAllocation(String collegeId) {
    final updated = widget.existingSeat!.copyWith(
      totalSeats: int.parse(seatsController.text),
      availableSeats: int.parse(seatsController.text), // adjust if needed
    );

    context.read<BranchBloc>().add(
      UpdateBranchSeatAllocationEvent(
        collegeId: collegeId,
        seatAllocation: updated,
      ),
    );

    Navigator.pop(context);
  }
}
