import 'package:animated_text_kit/animated_text_kit.dart';
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

import '../widgets/splash_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColorDark,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            context.pop();
          }
          if (state is UnAuthenticated) {
            context.goNamed('auth_phone');
          } else if (state is UserAlreadyLoggedIn) {
            context.read<AdminUserCubit>().setUser(state.adminUser);
            context.go('/dashboardScreen', extra: state.adminUser);
          }else if(state is UserIsNotRegistered){
            context.go('/selectCollege',extra: state.authInfo);
          }
          else if (state is AuthError) {
            AppUtils.showCustomSnackBar(context, state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                      letterSpacing: 1.2,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 800),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'MarkMe',
                          speed: const Duration(milliseconds: 120),
                          cursor: '.',
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Where Every Presence Counts",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                      fontSize: 18
                    ),
                  ),
                ],
              ),
              SplashButton(
                onTap: () {
                  context.read<AuthBloc>().add(CheckAuthStatus());
                },
                text: "continue",
                icon: Icons.navigate_next_rounded,
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
