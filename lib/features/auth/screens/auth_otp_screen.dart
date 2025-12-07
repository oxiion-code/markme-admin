import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_button.dart';
import 'package:markme_admin/core/widgets/otp_boxes.dart';
import 'package:markme_admin/features/auth/bloc/auth_bloc.dart';
import 'package:markme_admin/features/auth/bloc/auth_event.dart';
import 'package:markme_admin/features/auth/bloc/auth_state.dart';

import '../../onboarding/cubit/admin_user_cubit.dart';

class AuthOtpScreen extends StatefulWidget {

  final String verificationId;
  const AuthOtpScreen({super.key,required this.verificationId});

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocListener<AuthBloc,AuthState>(
        listener: (context,state){
          if(state is AuthLoading){
            AppUtils.showCustomLoading(context);
          }else{
            context.pop();
          }
          if(state is AuthenticationSuccess){
            if(state.isNewUser){
              context.go('/selectCollege',extra: state.authInfo);
            }else{
              if(state.adminUser!=null){
                context.read<AdminUserCubit>().setUser(state.adminUser!);
              }
              context.go('/dashboardScreen',extra: state.adminUser);
            }
          }else if(state is AuthError){
            AppUtils.showCustomSnackBar(context, state.error );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  SizedBox(
                    child: Lottie.asset(
                      "assets/animations/otp_animation.json",
                      height: 120,
                      width: 120,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24.0,
                      top: 12,
                      left: 24,
                      right: 24,
                    ),
                    child: Text(
                      "Please enter the OTP sent to your phone to complete verification.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.5
                      ),
                    ),
                  ),
                  OtpBoxes(controller: otpController),
                ],
              ),
              CustomButton(onTap: (){
                final otp=otpController.text.trim();
                if(otp.length==6){
                  context.read<AuthBloc>().add(VerifyOtpEvent(widget.verificationId, otp));
                }else{
                  AppUtils.showCustomSnackBar(context, "Enter a valid 6 digit OTP");
                }
              }, text: "Verify OTP", icon: null)
            ],
          ),
        ),
      ),
    );
  }
}
