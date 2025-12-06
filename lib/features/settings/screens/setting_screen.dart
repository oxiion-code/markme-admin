import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/auth/bloc/auth_bloc.dart';
import 'package:markme_admin/features/auth/bloc/auth_event.dart';
import 'package:markme_admin/features/auth/bloc/auth_state.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class SettingScreen extends StatefulWidget {
  final AdminUser admin;
  const SettingScreen({super.key,required this.admin });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future<void> showConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: (){
                context.read<AuthBloc>().add(LogoutRequested());
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context,state){
        if(state is LogoutSuccess){
          AppUtils.showCustomSnackBar(context, "Logout Success");
          context.go("/authPhone");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  context.push("/updateProfile",extra:  widget.admin);
                },
                title: Text(
                  "Update Personal Data",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  "Photo, Name, Email",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.grey),
                ),
                leading: const Icon(Icons.person),
                tileColor: Colors.blue.shade50,
              ),
              const SizedBox(height: 8),
              ListTile(
                onTap: () => showConfirmDialog(context), // ✅ FIXED
                title: Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  "Sign out from this device",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.grey.shade300),
                ),
                leading: const Icon(Icons.logout, color: Colors.white),
                tileColor: Colors.red.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
