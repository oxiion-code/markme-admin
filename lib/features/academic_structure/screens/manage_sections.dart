import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_state.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/widgets/section_widgets/add_section_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/section_widgets/section_card.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/filter_semester_app_bar.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';

import '../../teacher/models/teacher.dart';

class ManageSections extends StatefulWidget {
  const ManageSections({super.key});

  @override
  State<ManageSections> createState() => _ManageSectionsState();
}

class _ManageSectionsState extends State<ManageSections> {
  List<AcademicBatch>? batches;
  List<Branch>? branches;
  List<Teacher>? teachers;

  Branch? selectedBranch;

  @override
  void initState() {
    super.initState();
    final collegeId=context.read<AdminUserCubit>().state!.collegeId;
    context.read<SectionBloc>().add(LoadAllBranchesEvent(collegeId: collegeId));
  }

  // ------------------------ FILTER SHEET -------------------------
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Branch",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              ...branches!.map((branch) => ListTile(
                leading: Icon(
                  selectedBranch?.branchId == branch.branchId
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primary,
                ),
                title: Text(branch.branchName),
                onTap: () {
                  setState(() {
                    selectedBranch = branch;
                  });
                  Navigator.pop(context);

                  // Load batches of selected branch
                  context.read<SectionBloc>().add(
                    LoadAllBatchesEvent(branchId: branch.branchId,collegeId: collegeId),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------ ADD SECTION SHEET -------------------------
  void _showAddSectionSheet(BuildContext context,String collegeId) {
    if (branches == null || batches == null) {
      AppUtils.showCustomSnackBar(context, "Please wait, still loading...");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<SectionBloc>(),
        child: AddSectionBottomSheet(
          branches: branches!,
          onAddSectionClick: (section) {
            context.read<SectionBloc>().add(AddNewSectionEvent(section: section, collegeId: collegeId));
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final collegeId=context.read<AdminUserCubit>().state!.collegeId;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      appBar: SemesterAppNavBar(
        title: selectedBranch == null
            ? "Manage Sections"
            : "Manage Sections (${selectedBranch!.branchName})",
        onTap: () => _showBranchFilterSheet(context,collegeId),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Section",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _showAddSectionSheet(context,collegeId),
      ),

      body: BlocConsumer<SectionBloc, SectionState>(
        listener: (context, state) {
          if (state is SectionLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            if (Navigator.canPop(context)) Navigator.pop(context);
          }

          if (state is SectionError) {
            AppUtils.showCustomSnackBar(context, state.message);
          }

          if (state is SectionSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation successful");

            if (selectedBranch != null) {
              context.read<SectionBloc>().add(
                LoadAllSectionEvent(branchId: selectedBranch!.branchId,collegeId: collegeId),
              );
            }
          }

          if (state is BranchesLoaded) {
            branches = state.branches;
            if (branches!.isNotEmpty) {
              selectedBranch ??= branches!.first;

              context.read<SectionBloc>().add(
                LoadAllBatchesEvent(branchId: selectedBranch!.branchId,collegeId: collegeId),
              );
            }
          }

          if (state is BatchesLoaded) {
            batches = state.batches;

            if (selectedBranch != null) {
              context.read<SectionBloc>().add(
                LoadAllSectionEvent(branchId: selectedBranch!.branchId, collegeId: collegeId),
              );
            }
          }
        },

        builder: (context, state) {
          if (state is SectionsLoaded) {
            if (state.sections.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.cube_box, size: 70, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(
                      "No sections added yet",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.sections.length,
              itemBuilder: (context, index) {
                final section = state.sections[index];
                return SectionCard(
                  section: section,
                  onDelete: () {
                    AppUtils.showDeleteConfirmation(context: context, onConfirmDelete: (){
                      context.read<SectionBloc>().add(
                        DeleteSectionEvent(section: section, collegeId: collegeId),
                      );
                    });
                  },
                );
              },
            );
          }
          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }
}
