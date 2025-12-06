import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_button.dart';
import 'package:markme_admin/features/auth/bloc/auth_bloc.dart';
import 'package:markme_admin/features/auth/bloc/auth_event.dart';
import 'package:markme_admin/features/auth/bloc/auth_state.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BlocListener<AuthBloc,AuthState>(
        listener: (context,state){
          if(state is AuthLoading){
            AppUtils.showCustomLoading(context);
          }else {
            context.pop();
          }
          if(state is UnAuthenticated){
            context.goNamed('auth_phone');
          }else if(state is UserAlreadyLoggedIn){
            context.read<AdminUserCubit>().setUser(state.adminUser);
            context.go('/dashboardScreen', extra: state.adminUser);
          }else if(state is AuthError){
            AppUtils.showCustomSnackBar(context,state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      "assets/images/logo_no_brand_no_bg.png",
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Text(
                    "Where Every Presence Counts",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.5,
                    image: AssetImage("assets/images/gita_without_bg.png"),
                    fit: BoxFit.cover
                  ),
                ),
              ),

              CustomButton(
                onTap: () {
                  context.read<AuthBloc>().add(CheckAuthStatus());
                },
                text: "continue",
                icon: Icons.navigate_next_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
