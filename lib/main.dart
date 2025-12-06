import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/theme/app_theme.dart';
import 'package:markme_admin/core/services/service_locator.dart' as di;
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';
import 'package:markme_admin/navigation/app_router.dart';

import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_)=>AdminUserCubit())// AuthBloc lives throughout the app
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'NarkMe Admin ',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
