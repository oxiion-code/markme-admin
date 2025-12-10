import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/filter_semester_app_bar.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';
import '../../../core/utils/app_utils.dart';
import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../bloc/subject_bloc.dart';
import '../bloc/subject_event.dart';
import '../bloc/subject_state.dart';
import '../widgets/add_subject_bottom_sheet.dart';
import '../widgets/subject_card.dart';

class ManageSubjects extends StatefulWidget {
  const ManageSubjects({super.key});

  @override
  State<ManageSubjects> createState() => _ManageSubjectsState();
}

class _ManageSubjectsState extends State<ManageSubjects> {
  List<Branch>? branches;
  List<AcademicBatch>? batches;
  Branch? selectedBranch;

  @override
  void initState() {
    super.initState();
    final collegeId= context.read<AdminUserCubit>().state!.collegeId;
    context.read<SubjectBloc>().add(LoadAllBranches(collegeId: collegeId));
  }
  void _showBranchFilterSheet(BuildContext context,String collegeId) {
    if (branches == null || branches!.isEmpty) {
      AppUtils.showCustomSnackBar(context, "No branches available");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              "Select Branch",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            ...branches!.map(
                  (branch) => ListTile(
                leading: Icon(
                  selectedBranch?.branchId == branch.branchId
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: Colors.indigo,
                ),
                title: Text(branch.branchName),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedBranch = branch;
                  });

                  context.read<SubjectBloc>().add(
                    LoadAllBatches(collegeId: collegeId,branchId: selectedBranch!.branchId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------
  // SHOW ADD SUBJECT BOTTOM SHEET
  // -----------------------------------------------------
  void _showAddSubjectSheet(BuildContext context,String collegeId) {
    if (branches == null || batches == null) {
      AppUtils.showCustomSnackBar(context, "Please wait, still loading...");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddSubjectBottomSheet(
          branches: branches!,
          batches: batches!,
          onAddSubjectClick: (subject) {
            context.read<SubjectBloc>().add(AddSubjectEvent(subject,collegeId));
          },
        );
      },
    );
  }

  // -----------------------------------------------------
  // MAIN UI
  // -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final collegeId= context.read<AdminUserCubit>().state!.collegeId;
    return Scaffold(
      appBar: SemesterAppNavBar(
        title: selectedBranch == null
            ? "Manage Subjects"
            : "Manage Subjects (${selectedBranch!.branchName})",
        onTap: () => _showBranchFilterSheet(context,collegeId), // filter button
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Subject",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _showAddSubjectSheet(context,collegeId),
      ),

      body: BlocConsumer<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state is SubjectLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            if (Navigator.canPop(context)) Navigator.pop(context);
          }

          if (state is SubjectError) {
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is SubjectSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation Success");
          }

          if (state is BranchesLoaded) {
            setState(() {
              branches = state.branches;
              if (branches!.isNotEmpty) {
                selectedBranch = branches!.first;
                context.read<SubjectBloc>().add(
                  LoadAllBatches( collegeId:collegeId , branchId: selectedBranch!.branchId),
                );
              }
            });
          } else if (state is BatchesLoaded) {
            setState(() {
              batches = state.batches;
            });
            context.read<SubjectBloc>().add(GetAllSubjects(collegeId: collegeId));
          }
        },

        builder: (context, state) {
          if (state is SubjectLoaded) {
            final subjects = state.subjects;

            if (subjects.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.book, size: 70, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(
                      "No subjects added yet",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];

                return SubjectCard(
                  subject: subject,
                  onDelete: () {
                    context.read<SubjectBloc>().add(DeleteSubjectEvent(subject,collegeId));
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
