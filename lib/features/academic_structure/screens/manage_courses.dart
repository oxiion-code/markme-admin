import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_state.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/add_course_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/course_container.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/edit_course_bottom_sheet.dart';

import '../../../core/theme/color_scheme.dart';

class ManageCourses extends StatefulWidget {
  const ManageCourses({super.key});

  @override
  State<ManageCourses> createState() => _ManageCoursesState();
}

class _ManageCoursesState extends State<ManageCourses> {
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(LoadCourses());
  }

  void _showAddCourseSheet(BuildContext context) {
    final courseBloc = context.read<CourseBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: courseBloc,
          child: AddCourseBottomSheet(
            onAddClicked: (course) {
              courseBloc.add(AddCourseEvent(course));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondary,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        title: Text(
          'Manage Courses',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),

      // ✅ Floating Action Button instead of AppBar Button
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primaryDark,
          onPressed: () => _showAddCourseSheet(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add Course",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),


      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseLoading) {
            AppUtils.showCustomLoading(context);
          } else if (state is CourseError) {
            Navigator.of(context).pop(); // close loader
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is CourseLoaded) {
            Navigator.of(context).pop(); // close loader
          }
        },
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading && state is! CourseLoaded) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseLoaded) {
              final courses = state.courses;

              if (courses.isEmpty) {
                return SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.book_solid,
                          size: 70, color: AppColors.primaryDark),
                      const SizedBox(height: 12),
                      Text(
                        "No courses added yet.",
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseContainer(
                    course: course,
                    onEdit: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return EditCourseBottomSheet(
                            onSaveEdit: (updatedCourse) {
                              context.read<CourseBloc>().add(
                                UpdateCourseEvent(updatedCourse),
                              );
                            },
                            course: course,
                          );
                        },
                      );
                    },
                    onDelete: () {
                      context
                          .read<CourseBloc>()
                          .add(DeleteCourseEvent(course));
                    },
                  );
                },
              );
            } else if (state is CourseError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: AppColors.primaryDark),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
