import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_state.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/academic_structure/widgets/branch_widgets/add_branch_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/branch_widgets/branch_container.dart';
import 'package:markme_admin/features/academic_structure/widgets/branch_widgets/edit_branch_bottom_sheet.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/features/academic_structure/screens/branch/seat_allocation_list_screen.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';

class ManageBranches extends StatefulWidget {
  const ManageBranches({super.key});

  @override
  State<ManageBranches> createState() => _ManageBranchesState();
}

class _ManageBranchesState extends State<ManageBranches> {
  final TextEditingController branchId = TextEditingController();
  final TextEditingController branchName = TextEditingController();
  late List<Course>? courses;


  @override
  void initState() {
    super.initState();
    final collegeId= context.read<AdminUserCubit>().state!.collegeId;
    context.read<BranchBloc>().add(LoadCourseForBranchEvent(collegeId:collegeId ));
  }

  void _showAddBranchSheet(BuildContext context, String collegeId) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        if (courses != null && courses!.isNotEmpty) {
          return AddBranchBottomSheet(
            branchIdController: branchId,
            branchNameController: branchName,
            onAddClick: (branch) {
              context.read<BranchBloc>().add(AddNewBranchEvent(branch: branch,collegeId: collegeId));
              branchId.clear();
              branchName.clear();
              Navigator.pop(context);
            },
            courses: courses!,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.book, size: 60, color: Colors.indigo),
                  SizedBox(height: 16),
                  Text(
                    "Please add a course before creating a branch.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final collegeId=context.read<AdminUserCubit>().state!.collegeId;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        title: Text(
          'Manage Branches',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),

      // ✅ FAB to Add Branch
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryDark,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Branch",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _showAddBranchSheet(context,collegeId),
      ),

      body: BlocConsumer<BranchBloc, BranchState>(
        listener: (context, state) {
          if (state is BranchDataLoadingState) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.pop(context); // close any loader or sheet
          }

          if (state is BranchFailureState) {
            AppUtils.showCustomSnackBar(context, state.errorMessage);
          }

          if (state is LoadedCoursesForBranchState) {
            setState(() => courses = state.courses);
            context.read<BranchBloc>().add(LoadBranchesEvent(collegeId: collegeId));
          }

          if (state is BranchSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation successful");
            context.read<BranchBloc>().add(LoadBranchesEvent(collegeId: collegeId));
          }
        },
        builder: (context, state) {
          if (state is BranchesLoaded) {
            if (state.branches.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.book_solid, size: 70, color: Colors.indigo),
                    SizedBox(height: 10),
                    Text(
                      'No branches added yet.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: state.branches.length,
                itemBuilder: (context, index) {
                  final branch = state.branches[index];
                  return BranchContainer(
                    branch: branch,
                    onDelete: () {
                      context.read<BranchBloc>().add(DeleteBranchEvent(branch: branch,collegeId: collegeId));
                    },
                    onTap: (){
                      context.push('/seatAllocation', extra: branch);
                    },
                    onEdit: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => EditBranchBottomSheet(
                          onSaveEdit: (branch) {
                            context.read<BranchBloc>().add(UpdateBranchEvent(branch: branch,collegeId: collegeId));
                          },
                          branch: branch,
                          courses: courses ?? [],
                        ),
                      );
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
