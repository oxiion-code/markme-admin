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
import 'package:markme_admin/features/placement/models/session/placement_form.dart';
import 'package:markme_admin/features/placement/models/session/application_args.dart';
import 'package:markme_admin/features/placement/models/session/document_args.dart';
import 'package:markme_admin/features/placement/screens/applications/application_details_screen.dart';
import 'package:markme_admin/features/placement/screens/applications/document_viewer_screen.dart';
import 'package:markme_admin/features/placement/screens/applications/take_session_attendance_screen.dart';
import 'package:markme_admin/features/placement/screens/company/company_detail_screen.dart';
import 'package:markme_admin/features/placement/screens/company/placement_dashboard_screen.dart';
import 'package:markme_admin/features/placement/screens/applications/session_applications_screen.dart';
import 'package:markme_admin/features/placement/screens/company/session_detail_screen.dart';
import 'package:markme_admin/features/section_promotion/screens/section_promotion_screen.dart';
import 'package:markme_admin/features/settings/bloc/setting_bloc.dart';
import 'package:markme_admin/features/settings/screens/college_schdule_screen.dart';
import 'package:markme_admin/features/settings/screens/update_admin_screen.dart';
import 'package:markme_admin/features/student_onboarding/screens/section_allotment/students_for_section_list.dart';

import 'package:markme_admin/features/subjects/bloc/subject_bloc.dart';
import 'package:markme_admin/features/settings/screens/add_class_shedule_screen.dart';
import 'package:markme_admin/features/subjects/screens/manage_subjects.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_bloc.dart';
import 'package:markme_admin/features/teacher/screens/manage_teachers.dart';

import '../features/auth/screens/splash_screen.dart';
import '../features/placement/models/session/placement_session.dart';
import '../features/placement/screens/company/add_company_screen.dart';
import '../features/placement/screens/company/add_placement_session_screen.dart';
import '../features/settings/screens/setting_screen.dart';
import '../features/student_onboarding/bloc/student_verification_bloc.dart';
import '../features/student_onboarding/bloc/student_verification_event.dart';
import '../features/student_onboarding/models/qualification.dart';
import '../features/student_onboarding/models/student_list_args.dart';
import '../features/student_onboarding/models/student_verification_args.dart';
import '../features/student_onboarding/screens/section_allotment/student_section_allotment_filter.dart';
import '../features/student_onboarding/screens/student_onboarding.dart';
import '../features/student_onboarding/screens/student_verification/pdf_viewer_screen.dart';
import '../features/student_onboarding/screens/student_verification/student_verification_confirmation_screen.dart';
import '../features/student_onboarding/screens/student_verification/student_verification_filter_screen.dart';
import '../features/student_onboarding/screens/student_verification/students_verification_list_screen.dart';

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
      path: '/student-verification-filter',
      name: 'student_verification_filter',
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return BlocProvider(
          create: (_) => StudentOnboardingBloc(
            verificationRepository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            academicBatchRepository: sl(),
            sectionRepository: sl(),
          )..add(
            LoadCoursesForStudentEvent(collegeId: admin.collegeId),
          ),
          child: StudentVerificationFilterScreen(
            collegeId: admin.collegeId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/section-allotment-filter',
      name: 'section_allotment_filter',
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return BlocProvider(
          create: (_) => StudentOnboardingBloc(
            verificationRepository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            academicBatchRepository: sl(),
            sectionRepository: sl(),
          ),
          child: SectionAllotmentFilterScreen(collegeId: admin.collegeId),
        );
      },
    ),
    GoRoute(
      path: '/section-allotment-list',
      name: 'section_allotment_list',
      builder: (context, state) {
        final args = state.extra as StudentListArgs;
        return BlocProvider(
          create: (_) => StudentOnboardingBloc(
            verificationRepository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            academicBatchRepository: sl(),
            sectionRepository: sl(),
          ),
          child: SectionAllotmentScreen(args: args),
        );
      },
    ),
    GoRoute(
      path: '/student-verification-list',
      name: 'student_verification_list',
      builder: (context, state) {
        final studentArgs = state.extra as StudentListArgs;
        return BlocProvider(
          create: (_) => StudentOnboardingBloc(
            verificationRepository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            academicBatchRepository: sl(),
            sectionRepository: sl(),
          ),
          child: StudentVerificationListScreen(
            students: studentArgs.students,
            collegeId: studentArgs.collegeId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/student-verification-details',
      name: 'student_verification_details',
      builder: (context, state) {
        final studentArgs = state.extra as StudentVerificationArgs;
        return BlocProvider(
          create: (_) => StudentOnboardingBloc(
            verificationRepository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            academicBatchRepository: sl(),
            sectionRepository: sl(),
          ),
          child: StudentVerificationConfirmationScreen(
            student: studentArgs.student,
            collegeId: studentArgs.collegeId,
          ),
        );
      },
    ),
    GoRoute(
      path: "/student-document",
      builder: (context, state) {
        final qualification = state.extra as Qualification;
        return PdfViewerScreen(qualification: qualification);
      },
    ),
    GoRoute(
      path: "/student-onboarding",
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return StudentOnboardingScreen(admin: admin);
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
          create: (_) => SectionBloc(sl(), sl(), sl(), sl(),sl()),
          child: ManageSections(),
        );
      },
    ),
    GoRoute(
      path: '/promote-sections',
      name: 'promote_sections',
      builder: (context, state) {
        final admin=state.extra as AdminUser;
        return BlocProvider(
          create: (_) => SectionBloc(sl(), sl(), sl(), sl(),sl()),
          child: SectionPromotionScreen(collegeId: admin.collegeId),
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
        final admin=state.extra as AdminUser;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CompanyBloc(repository: sl())),
            // Add more BlocProviders here if needed
          ],
          child: PlacementDashboardScreen(adminUser: admin,),
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
          child: SessionDetailScreen(
            collegeId: data['collegeId']!,
            sessionId: data['sessionId']!,
          ),
        );
      },
    ),
    GoRoute(path: '/sessionApplications',
      builder: (context, state) {
       final args= state.extra as ApplicationArgs;
        return BlocProvider(
          create: (_) => PlacementSessionBloc(
            repository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            batchRepository: sl(),
          ),
          child: PlacementSessionApplicationsScreen(collegeId: args.collegeId, session: args.placementSession),
        );
      },
    ),
    GoRoute(path: '/take-attendance',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final String collegeId = args['collegeId'];
        final PlacementSession session = args['session'];
        final List<PlacementForm> applications = args['applications'];
        return BlocProvider(
          create: (_) => PlacementSessionBloc(
            repository: sl(),
            courseRepository: sl(),
            branchRepository: sl(),
            batchRepository: sl(),
          ),
          child: TakeSessionAttendanceScreen(collegeId: collegeId, session: session, applications: applications),
        );
      },
    ),
    GoRoute(
      path: "/application-details",
      name: "application_details",
      builder: (context, state) {
        final application = state.extra as PlacementForm;
        return PlacementApplicationDetailsScreen(application: application);
      },
    ),
    GoRoute(
      path: "/document",
      name: "document",
      builder: (context, state) {
        final args = state.extra as DocumentArgs;
        return PdfUrlViewerScreen(pdfUrl: args.url,title: args.title,);
      },
    ),
    GoRoute(
      path: '/collegeSchedule',
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return BlocProvider(
          create: (_) => SettingBloc(sl()),
          child: CollegeScheduleDetailsScreen(adminUser: admin),
        );
      },
    ),
    GoRoute(
      path: '/addCollegeSchedule',
      builder: (context, state) {
        final admin = state.extra as AdminUser;
        return BlocProvider(
          create: (_) => SettingBloc(sl()),
          child: CollegeScheduleScreen(adminUser: admin),
        );
      },
    ),

  ],
);
