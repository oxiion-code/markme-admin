import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/core/constants/constant_values.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_button.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/auth/bloc/auth_bloc.dart';
import 'package:markme_admin/features/auth/bloc/auth_event.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_bloc.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_event.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_state.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/onboarding/widgets/profile_image_picker.dart';

import '../cubit/admin_user_cubit.dart';

class PersonalInfoScreen extends StatefulWidget {
  final AuthInfo authInfo;
  const PersonalInfoScreen({super.key, required this.authInfo});
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  bool isSuperAdmin = false;
  File? _selectedImage;
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _handleImagePicker(File pickedImage) {
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    // TODO: implement build
    return Scaffold(
      body: BlocListener<OnboardBloc, OnboardState>(
        listener: (context, state) {
          if (state is OnboardLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            context.pop();
          }
          if (state is OnboardSuccess) {
            context.read<AdminUserCubit>().setUser(state.user);
            AppUtils.saveCollegeId(state.user.collegeId);
            context.go('/dashboardScreen', extra: state.user);
          } else if (state is OnboardError) {
            context.read<AuthBloc>().add(LogoutRequested());
            AppUtils.showCustomSnackBar(context, state.errorMessage);
            context.goNamed('auth_phone');
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding + 5,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Personal Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.primaryDark,
                        ),
                      ),

                      const SizedBox(height: 16),
                      ProfileImagePicker(onImagePicked: _handleImagePicker),
                      const SizedBox(height: 16),
                      CustomTextbox(
                        controller: nameController,
                        hint: "Enter full name",
                        icon: Icons.perm_identity,
                      ),
                      CheckboxListTile(
                        value: isSuperAdmin,
                        onChanged: (value) {
                          setState(() {
                            isSuperAdmin = value!;
                          });
                        },
                        title: Text(
                          "Are you super admin?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSuperAdmin ? Colors.blue : Colors.grey,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  CustomButton(
                    onTap: () {
                      if (_selectedImage == null ||
                          nameController.text.trim().isEmpty) {
                        AppUtils.showCustomSnackBar(
                          context,
                          'Add photo and name to proceed',
                        );
                      } else {
                        context.read<OnboardBloc>().add(
                          SubmitPersonalInfoEvent(
                            user: AdminUser(
                              uid: widget.authInfo.uid,
                              deviceToken: "",
                              name: nameController.text.trim(),
                              phone: widget.authInfo.phoneNumber,
                              email: '',
                              role: Constants.adminRole,
                              collegeId:
                                  widget.authInfo.collegeId ??
                                  Constants.collegeId,
                              collegeName:
                                  widget.authInfo.collegeName ??
                                  Constants.collegeName,
                              designation: isSuperAdmin
                                  ? Constants.superAdminRole
                                  : Constants.adminRole,
                              adminType: isSuperAdmin
                                  ? Constants.superAdminRole
                                  : Constants.adminRole,
                              joinedAt: DateFormat(
                                'dd MMMM yyyy',
                              ).format(DateTime.now()),
                              profilePhotoUrl: '',
                              bannerLink:widget.authInfo.bannerLink
                            ),
                            profileImage: _selectedImage,
                            isSuperAdmin: isSuperAdmin,
                          ),
                        );
                      }
                    },
                    text: "Create account",
                    icon: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
