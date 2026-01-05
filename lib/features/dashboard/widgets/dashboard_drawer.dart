import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AdminUserCubit>().state;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.cardBg,
            height: 220,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user?.profilePhotoUrl ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.name ?? "Unknown",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_tree),
            title: const Text('Academic Structure'),
            onTap: () {
              context.pop();
              context.push('/manageAcademicStructure');
            },
          ),
          ListTile(
            leading: Icon(Icons.cast_for_education),
            title: const Text('Student Onboarding'),
            onTap: () {
              context.pop();
              context.push("/student-onboarding", extra: user);
            },
          ),
          ListTile(
            leading: Icon(Icons.perm_device_info_sharp),
            title: const Text('Manage Permissions'),
            onTap: () {
              context.pop();
              context.pushNamed("manage_permissions", extra: user);
            },
          ),

          ListTile(
            leading: Icon(Icons.plagiarism),
            title: const Text('Manage Placement'),
            onTap: () {
              context.pop();
              context.push('/managePlacement',extra: user);
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: const Text('Manage Subjects'),
            onTap: () {
              context.pop();
              context.push('/manageSubjects');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_2_rounded),
            title: const Text('Manage Teachers'),
            onTap: () {
              context.pop();
              context.push('/manageTeachers');
            },
          ),
          ListTile(
            leading: Icon(Icons.upgrade_sharp),
            title: const Text('Promote Sections'),
            onTap: () {
              context.pop();
              context.push('/promote-sections',extra: user);
            },
          ),

          // ListTile(
          //   leading: Icon(Icons.history_outlined),
          //   title: const Text('Past Classes'),
          //   onTap: (){
          //     context.pop();
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.pop();
              context.push("/settings", extra: user);
            },
          ),
        ],
      ),
    );
  }
}
