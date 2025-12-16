import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/services/service_locator.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_bloc.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_academic_structure_screen.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_batches.dart';
import 'package:markme_admin/features/academic_structure/screens/branch/manage_branches.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_courses.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_sections.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_semesters.dart';
import 'package:markme_admin/features/academic_structure/screens/branch/seat_allocation_list_screen.dart';
import 'package:markme_admin/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_admin/features/attendance/screens/current_session_attendance_screen.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';
import 'package:markme_admin/features/auth/screens/auth_otp_screen.dart';
import 'package:markme_admin/features/auth/screens/auth_phone_no_screen.dart';
import 'package:markme_admin/features/classes/models/class_session.dart';
import 'package:markme_admin/features/classes/screens/manage_classes.dart';
import 'package:markme_admin/features/current_session/bloc/current_session_bloc.dart';
import 'package:markme_admin/features/dashboard/screens/admin_dashboard_screen.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_bloc.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/onboarding/screens/personal_info_screen.dart';
import 'package:markme_admin/features/onboarding/screens/select_college_screen.dart';
import 'package:markme_admin/features/permissions/screens/manage_permissions_screen.dart';
import 'package:markme_admin/features/permissions/screens/student_permissions_screen.dart';
import 'package:markme_admin/features/placement/blocs/company/company_bloc.dart';
import 'package:markme_admin/features/placement/blocs/session/session_bloc.dart';
import 'package:markme_admin/features/placement/models/company/company_details.dart';
import 'package:markme_admin/features/placement/screens/company_detail_screen.dart';
import 'package:markme_admin/features/placement/screens/placement_dashboard_screen.dart';
import 'package:markme_admin/features/placement/screens/session_detail_screen.dart';
import 'package:markme_admin/features/settings/bloc/setting_bloc.dart';
import 'package:markme_admin/features/settings/screens/update_admin_screen.dart';
import 'package:markme_admin/features/subjects/bloc/subject_bloc.dart';
import 'package:markme_admin/features/subjects/screens/manage_subjects.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_bloc.dart';
import 'package:markme_admin/features/teacher/screens/manage_teachers.dart';

import '../features/auth/screens/splash_screen.dart';
import '../features/placement/screens/add_company_screen.dart';
import '../features/placement/screens/add_placement_session_screen.dart';
import '../features/settings/screens/setting_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: '/authPhone',
      name: 'auth_phone',
      builder: (context, state) => AuthPhoneNumberScreen(),
    ),
    GoRoute(
      path: '/authOtp',
      name: 'auth_otp',
      builder: (context, state) {
        final String verificationId = state.extra as String;
        return AuthOtpScreen(verificationId: verificationId);
      },
    ),
    GoRoute(
      path: '/selectCollege',
      name: 'select_college',
      builder: (context, state) {
        final authInfo = state.extra as AuthInfo;
        return BlocProvider(
          create: (_) => OnboardBloc(sl()),
          child: SelectCollegeScreen(authInfo: authInfo),
        );
      },
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) {
        final authInfo = state.extra as AuthInfo;
        return BlocProvider(
          create: (_) => OnboardBloc(sl()), // This is a separate bloc — fine!
          child: PersonalInfoScreen(authInfo: authInfo),
        );
      },
    ),
    GoRoute(
      path: '/dashboardScreen',
      name: 'dashboard_screen',
      builder: (context, state) {
        final user = state.extra as AdminUser;
        return BlocProvider(
          create: (_) => CurrentSessionBloc(repository: sl()),
          child: DashboardScreen(user: user),
        ); // AuthBloc already available from root
      },
    ),
    GoRoute(
      path: '/manageAcademicStructure',
      name: 'manage_academic_structure',
      builder: (context, state) {
        return ManageAcademicStructureScreen();
      },
    ),
    GoRoute(
      path: '/manageCourses',
      name: 'manage_courses',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => CourseBloc(sl()),
          child: ManageCourses(),
        );
      },
    ),
    GoRoute(
      path: '/manageBranches',
      name: 'manage_branches',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => BranchBloc(sl(), sl()),
          child: ManageBranches(),
        );
      },
    ),
    GoRoute(
      path: '/manageSemesters',
      name: 'manage_semesters',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SemesterBloc(sl(), sl()),
          child: ManageSemesters(),
        );
      },
    ),
    GoRoute(
      path: '/manageBatches',
      name: 'manage_batches',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AcademicBatchBloc(sl(), sl()),
          child: ManageBatches(),
        );
      },
    ),
    GoRoute(
      path: '/manageSections',
      name: 'manage_sections',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SectionBloc(sl(), sl(), sl(), sl()),
          child: ManageSections(),
        );
      },
    ),
    GoRoute(
      path: '/manageSubjects',
      name: 'manage_subjects',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SubjectBloc(sl(), sl(), sl()),
          child: ManageSubjects(),
        );
      },
    ),
    GoRoute(
      path: '/manageTeachers',
      name: 'manage_teachers',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => TeacherBloc(sl(), sl()),
          child: ManageTeachers(),
        );
      },
    ),
    GoRoute(
      path: '/manageClasses',
      name: 'manage_classes',
      builder: (context, state) {
        return ManageClasses();
      },
    ),
    GoRoute(
      path: "/currentSessionAttendance",
      name: 'current_session_attendance',
      builder: (context, state) {
        final classSession = state.extra as ClassSession;
        return BlocProvider(
          create: (_) => AttendanceBloc(attendanceRepository: sl()),
          child: CurrentSessionAttendanceScreen(classSession: classSession),
        );
      },
    ),
    GoRoute(
      path: "/settings",
      name: "settings",
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return SettingScreen(admin: admin);
      },
    ),
    GoRoute(
      path: "/updateProfile",
      name: "update_profile",
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return BlocProvider(
          create: (_) => SettingBloc(sl()),
          child: UpdateAdminScreen(adminUser: admin),
        );
      },
    ),
    GoRoute(
      path: "/managePermissions",
      name: "manage_permissions",
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return ManagePermissionOptionScreen(adminUser: admin);
      },
    ),
    GoRoute(
      path: "/studentPermissions",
      name: "student_permissions",
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return StudentPermissionScreen();
      },
    ),
    GoRoute(
      path: '/seatAllocation',
      builder: (context, state) {
        final branch = state.extra as Branch;
        return BlocProvider(
          create: (_) => BranchBloc(sl(), sl()),
          child: SeatAllocationListScreen(branch: branch),
        );
      },
    ),
    GoRoute(
      path: '/managePlacement',
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CompanyBloc(repository: sl())),
            // Add more BlocProviders here if needed
          ],
          child: PlacementDashboardScreen(),
        );
      },
    ),
    GoRoute(
      path: '/addOrModifyCompany',
      builder: (context, state) {
        final collegeId = state.extra as String;
        return BlocProvider(
          create: (_) => CompanyBloc(repository: sl()),
          child: AddCompanyScreen(collegeId: collegeId),
        );
      },
    ),
    GoRoute(
      path: '/companyDetails',
      builder: (context, state) {
        final companyDetails = state.extra as CompanyDetails;
        return BlocProvider(
          create: (_) => CompanyBloc(repository: sl()),
          child: CompanyDetailsScreen(
            company: companyDetails.company,
            collegeId: companyDetails.collegeId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/addPlacementSession',
      builder: (context, state) {
        final companyDetails = state.extra as CompanyDetails;
        return BlocProvider(
          create: (_) => PlacementSessionBloc(
            repository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            batchRepository: sl(),
          ),
          child: AddPlacementSessionScreen(companyDetails: companyDetails),
        );
      },
    ),
    GoRoute(
      path: '/placementSessionDetails',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;

        return BlocProvider(
          create: (_) => PlacementSessionBloc(
            repository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            batchRepository: sl(),
          ),
          child: SessionDetailScreen(collegeId: data['collegeId']!,
            sessionId: data['sessionId']!,),
        );
      },
    ),
  ],
);
