import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_state.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/widgets/batch_widgets/add_batch_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/batch_widgets/batch_container.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/filter_semester_app_bar.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';

class ManageBatches extends StatefulWidget {
  const ManageBatches({super.key});

  @override 
  State<ManageBatches> createState() => _ManageBatchesState();
}

class _ManageBatchesState extends State<ManageBatches> {
  List<Branch>? branches;
  Branch? selectedBranch;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    final collegeId=context.read<AdminUserCubit>().state!.collegeId;
    context.read<AcademicBatchBloc>().add(LoadAllBranchesEvent(collegeId: collegeId));
  }

  final List<IconData> _icons = const [
    Icons.book,
    Icons.school,
    Icons.lightbulb,
    Icons.check_circle,
    Icons.schedule,
    Icons.people,
    Icons.laptop_mac,
    Icons.science,
    Icons.code,
  ];

  final List<Color> _standardColors = const [
    Color(0xFF1E3A8A),
    Color(0xFF2563EB),
    Color(0xFF4B5563),
    Color(0xFF7C3AED),
    Color(0xFF047857),
    Color(0xFFC2410C),
  ];

  IconData getRandomIcon() => _icons[random.nextInt(_icons.length)];
  Color getRandomColor() =>
      _standardColors[random.nextInt(_standardColors.length)];

  void _showAddBatchSheet(BuildContext context,String collegeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        if (branches == null) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return AddBatchBottomSheet(
          branches: branches!,
          onAddBatchClick: (batch) {
            context.read<AcademicBatchBloc>().add(AddBatchEvent(batch,collegeId));
          },
        );
      },
    );
  }
  void _showBranchFilterSheet(BuildContext context,String collegeId) {
    if (branches == null || branches!.isEmpty) {
      AppUtils.showCustomSnackBar(context, "No branches available");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important: allows it to expand properly
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          // Prevent keyboard overlap
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: AppColors.primary,
                  ),
                  title: Text(branch.branchName),
                  onTap: () {
                    setState(() {
                      selectedBranch = branch;
                    });
                    Navigator.pop(context);
                    context.read<AcademicBatchBloc>().add(
                      LoadAllBatchesEvent(branchId: branch.branchId, collegeId: collegeId),
                    );
                  },
                ),
              ),
            ],
          ),
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
            ? "Manage Batches"
            : "Manage Batches (${selectedBranch!.branchName})",
        onTap: () => _showBranchFilterSheet(context,collegeId), // filter button
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Batch",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _showAddBatchSheet(context,collegeId),
      ),
      body: BlocConsumer<AcademicBatchBloc, AcademicBatchState>(
        listener: (context, state) {
          if (state is AcademicBatchLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is BranchesLoaded) {
            setState(() {
              branches = state.branches;
              if (branches!.isNotEmpty && selectedBranch == null) {
                selectedBranch = branches!.first;
                context.read<AcademicBatchBloc>().add(
                  LoadAllBatchesEvent(
                      branchId: selectedBranch!.branchId,collegeId: collegeId),
                );
              }
            });
          } else if (state is AcademicBatchError) {
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is AcademicBatchAdded) {
            AppUtils.showCustomSnackBar(context, "New academic batch added");
            if (selectedBranch != null) {
              context.read<AcademicBatchBloc>().add(
                LoadAllBatchesEvent(branchId: selectedBranch!.branchId,collegeId: collegeId),
              );
            }
          }else if(state is AcademicBatchDeleted){
            AppUtils.showCustomSnackBar(context, "Deleted Batch");
            if(selectedBranch!= null){
              context.read<AcademicBatchBloc>().add(
                LoadAllBatchesEvent(branchId: selectedBranch!.branchId,collegeId: collegeId),
              );
            }
          }else if(state is AcademicBatchUpdated){
            if(selectedBranch!=null){
              context.read<AcademicBatchBloc>().add(
                LoadAllBatchesEvent(branchId: selectedBranch!.branchId,collegeId: collegeId),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is AcademicBatchesLoaded) {
            if (state.batches.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.cube_box, size: 70, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(
                      "No batches added yet",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.batches.length,
                itemBuilder: (context, index) {
                  AcademicBatch batch = state.batches[index];
                  return BatchContainer(
                    batchName: batch.batchId,
                    iconData: getRandomIcon(),
                    cardColor: getRandomColor(),
                    rightCornerButtonIcon: Icons.delete_outline,
                    rightCornerButtonIconColor: Colors.redAccent,
                    onRightCornerButtonPressed: () {
                      context
                          .read<AcademicBatchBloc>()
                          .add(DeleteBatchEvent(collegeId: collegeId,batch: batch));
                    },
                  );
                },
              ),
            );
          }
          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }
}
