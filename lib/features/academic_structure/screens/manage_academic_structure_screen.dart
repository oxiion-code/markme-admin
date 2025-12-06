import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/manage_item_container.dart';

class ManageAcademicStructureScreen extends StatelessWidget {
  const ManageAcademicStructureScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        backgroundColor: AppColors.secondary,
        title: Text(
          'Manage Academic Structure',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ManageItemContainer(
              image: 'assets/images/courses_bg.jpg',
              onTap: () {
                context.push('/manageCourses');
              },
              title: 'Manage Courses',
              subTitle: 'Add, edit, or remove course offerings',
            ),
            ManageItemContainer(
              image: 'assets/images/branch_2_bg.png',
              onTap: () {
                context.push('/manageBranches');
              },
              title: 'Manage Branches',
              subTitle: 'Create, edit, and organise branches',
            ),
            ManageItemContainer(
              image: 'assets/images/semester_bg.png',
              onTap: () {
                context.push('/manageSemesters');
              },
              title: 'Manage Semesters',
              subTitle: 'Create, edit, and organise semesters',
            ),
            ManageItemContainer(
              image: 'assets/images/batch_bg.png',
              onTap: () {
                context.push('/manageBatches');
              },
              title: 'Manage Batches',
              subTitle: 'Configure batches like 2023-2024, 2003-2008,  branch and course',
            ),
            ManageItemContainer(
              image: 'assets/images/sections_bg.png',
              onTap: () {
                context.push('/manageSections');
              },
              title: 'Manage Sections',
              subTitle: 'Configure sections like A, B, or CSE I, ECE II based on branch and semester',
            ),
          ],
        ),
      ),
    );
  }
}
