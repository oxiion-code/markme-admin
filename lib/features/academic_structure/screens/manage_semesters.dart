import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_state.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/add_new_semester_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/edit_semester_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/semester_container.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';

import '../widgets/semester_widget/filter_course_bottom_sheet.dart';
import '../widgets/semester_widget/filter_semester_app_bar.dart';

class ManageSemesters extends StatefulWidget {
  const ManageSemesters({super.key});

  @override
  State<ManageSemesters> createState() => _ManageSemestersState();
}

class _ManageSemestersState extends State<ManageSemesters> {
  List<Course>? courses;
  Course? selectedCourse;

  @override
  void initState() {

    super.initState();
    final admin=context.read<AdminUserCubit>().state;
    context.read<SemesterBloc>().add(LoadCoursesEvent(collegeId: admin!.collegeId));
  }

  /// Opens bottom sheet to add new semester
  void _showAddSemesterBottomSheet(String collegeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        if (courses != null) {
          return AddSemesterBottomSheet(
            courses: courses!,
            addSemester: (semester) {
              context.read<SemesterBloc>().add(AddNewSemesterEvent(semester,collegeId));
            },
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  void _showFilterBottomSheet(String collegeId) {
    if (courses == null || courses!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No courses available")),
      );
      return;
    }
    final parentContext=context;
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterCourseBottomSheet(
          courses: courses!,
          onCourseSelected: (course) {
            setState(() {
              selectedCourse=course;
            });
            parentContext.read<SemesterBloc>().add(
              LoadSemestersEvent(courseId: course.courseId,collegeId: collegeId),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final collegeId= context.read<AdminUserCubit>().state!.collegeId;
    return Scaffold(
      appBar: SemesterAppNavBar(
        title: selectedCourse != null
            ? 'Semesters - ${selectedCourse!.courseName}'
            : 'Manage Semesters',
        onTap: (){
          _showFilterBottomSheet(collegeId);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: (){
          _showAddSemesterBottomSheet(collegeId);
        },
        label: const Text(
          "Add Semester",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<SemesterBloc, SemesterState>(
        listener: (context, state) {
          if (state is SemesterLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.pop(context); // close loading dialog if open
          }

          if (state is CoursesLoaded) {
            setState(() {
              courses = state.courses;
            });
            if (courses != null && courses!.isNotEmpty) {
              selectedCourse = courses!.first;
              context
                  .read<SemesterBloc>()
                  .add(LoadSemestersEvent(courseId: selectedCourse!.courseId,collegeId: collegeId));
            }
          } else if (state is SemesterFailure) {
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is SemesterSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation Successful");
          }
        },
        builder: (context, state) {
          if (state is SemestersLoaded) {
            if (state.semesters.isEmpty) {
              return const Center(
                child: Text(
                  "No semesters found for this course.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: state.semesters.length,
                itemBuilder: (context, index) {
                  final semester = state.semesters[index];
                  return SemesterContainer(
                    semester: semester,
                    onEdit: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return EditSemesterBottomSheet(
                            semester: semester,
                            courses: courses!,
                            onSaveEdit: (updatedSemester) {
                              context.read<SemesterBloc>().add(
                                UpdateSemesterEvent(updatedSemester,collegeId),
                              );
                            },
                          );
                        },
                      );
                    },
                    onDelete: () {
                      context
                          .read<SemesterBloc>()
                          .add(DeleteSemesterEvent(semester,collegeId));
                    },
                  );
                },
              ),
            );
          }

          return const Center(
          );
        },
      ),
    );
  }
}
