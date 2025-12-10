import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/app_nav_bar.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_bloc.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_event.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_state.dart';
import 'package:markme_admin/features/teacher/widgets/teacher_card.dart';

import '../models/teacher.dart';
import '../widgets/add_teacher_bottom_sheet.dart';

class ManageTeachers extends StatefulWidget {
  const ManageTeachers({super.key});

  @override
  State<ManageTeachers> createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  List<Branch>? branches;
  String? selectedBranchId; // 🔍 Filter branch ID

  @override
  void initState() {
    super.initState();
    final collegeId=context.read<AdminUserCubit>().state!.collegeId;
    context.read<TeacherBloc>().add(LoadBranchesForTeacherEvent(collegeId: collegeId));
  }

  void _openAddTeacherSheet(String collegeId) {
    if (branches != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => AddTeacherBottomSheet(
          branches: branches!,
          onAddTeacherClick: ({
            required teacherId,
            required name,
            required email,
            required branchId,
            required phoneNumber
          }) {
            final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
            context.read<TeacherBloc>().add(
              AddTeacherEvent(
                teacher: Teacher(
                  teacherId: teacherId,
                  teacherName: name,
                  email: email,
                  branchId: branchId,
                  phoneNumber: "91$phoneNumber",
                  profilePhotoUrl: "",
                  gender: "",
                  assignedClasses: [],
                  dateOfJoining: currentDate,
                  designation: "",
                  role: "",
                  subjects: [],
                  totalPoints: "",
                  deviceToken: "",
                ),
                collegeId: collegeId
              ),
            );
          },
        ),
      );
    } else {
      AppUtils.showDialogMessage(
        context,
        "Branches not loaded",
        "Please wait a moment.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String collegeId= context.read<AdminUserCubit>().state!.collegeId;
    return Scaffold(
      appBar: CustomAppNavBar(
        title: "Manage Teachers",
        onTap: ()=>_openAddTeacherSheet(collegeId),
      ),
      
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.of(context, rootNavigator: true).maybePop();
          }

          if (state is TeacherSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation successful");
          } else if (state is LoadBranchesForTeacher) {
            setState(() {
              branches = state.branches;
            });
            context.read<TeacherBloc>().add(LoadTeachersEvent(collegeId: collegeId));
          } else if (state is TeacherError) {
            AppUtils.showCustomSnackBar(context, state.message);
          }
        },

        builder: (context, state) {
          if (state is TeachersLoaded) {
            final teachers = state.teachers;

            if (teachers.isEmpty) {
              return const Center(child: Text("No teachers added yet"));
            }

            // 🔍 APPLY FILTER
            final filteredTeachers = selectedBranchId == null
                ? teachers
                : teachers.where((t) => t.branchId == selectedBranchId).toList();

            return Column(
              children: [
                // 🔍 Filter Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedBranchId,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(12),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 22,
                          decoration: InputDecoration(
                            labelText: "Filter by Branch",
                            hintText: "Select branch",
                            prefixIcon: const Icon(Icons.account_tree_outlined),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          items: branches?.map((b) {
                            return DropdownMenuItem<String>(
                              value: b.branchId,
                              child: Text(
                                b.branchName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList() ??
                              [],
                          onChanged: (value) {
                            setState(() {
                              selectedBranchId = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),

                // 🔥 Teachers List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTeachers.length,
                    itemBuilder: (context, index) {
                      final teacher = filteredTeachers.reversed.toList()[index];
                      return TeacherCard(
                        teacher: teacher,
                        onDelete: () => AppUtils.showDeleteConfirmation(
                          context: context,
                          onConfirmDelete: () {
                            context.read<TeacherBloc>().add(DeleteTeacherEvent(teacher: teacher,collegeId: collegeId));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No teachers added yet"));
        },
      ),
    );
  }
}
