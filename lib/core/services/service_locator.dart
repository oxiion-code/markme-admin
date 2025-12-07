import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_bloc.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository_impl.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository_impl.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository_impl.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository_impl.dart';
import 'package:markme_admin/features/academic_structure/repository/semester_repo/semester_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/semester_repo/semester_repository_impl.dart';
import 'package:markme_admin/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_admin/features/attendance/repositories/attendance_repository.dart';
import 'package:markme_admin/features/attendance/repositories/attendnace_repository_impl.dart';
import 'package:markme_admin/features/auth/bloc/auth_bloc.dart';
import 'package:markme_admin/features/auth/repository/auth_repository.dart';
import 'package:markme_admin/features/auth/repository/auth_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markme_admin/features/classes/bloc/class_bloc.dart';
import 'package:markme_admin/features/classes/repository/class_repository.dart';
import 'package:markme_admin/features/classes/repository/class_repository_impl.dart';
import 'package:markme_admin/features/onboarding/repository/onboard_repository.dart';
import 'package:markme_admin/features/onboarding/repository/onboard_repository_impl.dart';
import 'package:markme_admin/features/settings/bloc/setting_bloc.dart';
import 'package:markme_admin/features/settings/repositoies/setting_repository.dart';
import 'package:markme_admin/features/settings/repositoies/setting_repository_impl.dart';
import 'package:markme_admin/features/subjects/bloc/subject_bloc.dart';
import 'package:markme_admin/features/subjects/repository/subject_repository.dart';
import 'package:markme_admin/features/subjects/repository/subject_repository_impl.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_bloc.dart';
import 'package:markme_admin/features/teacher/repository/teacher_repository.dart';
import 'package:markme_admin/features/teacher/repository/teacher_repository_impl.dart';

import '../../features/current_session/bloc/current_session_bloc.dart';


final sl=GetIt.instance;

Future<void> init() async{

  // firebase services
  sl.registerLazySingleton<FirebaseAuth>(()=>FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(()=> FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(()=>FirebaseStorage.instance);

  //Repositories
  sl.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<OnboardRepository>(()=>OnboardRepositoryImpl(sl(),sl()));
  sl.registerLazySingleton<CourseRepository>(()=>CourseRepositoryImpl(sl()));
  sl.registerLazySingleton<BranchRepository>(()=>BranchRepositoryImpl(sl()));
  sl.registerLazySingleton<SemesterRepository>(()=>SemesterRepositoryImpl(sl()));
  sl.registerLazySingleton<AcademicBatchRepository>(()=>AcademicBatchRepositoryImpl(sl()));
  sl.registerLazySingleton<SectionRepository>(()=>SectionRepositoryImpl(sl()));
  sl.registerLazySingleton<SubjectRepository>(()=>SubjectRepositoryImpl(sl()));
  sl.registerLazySingleton<TeacherRepository>(()=>TeacherRepositoryImpl(sl()));
  sl.registerLazySingleton<ClassRepository>(()=>ClassRepositoryImpl(sl()));
  sl.registerLazySingleton<AttendanceRepository>(()=>AttendanceRepositoryImpl(firestore: sl()));
  sl.registerLazySingleton<SettingRepository>(()=>SettingRepositoryImpl(sl(), sl()));

  //blocs
  sl.registerFactory<AuthBloc>(()=>AuthBloc(sl()));
  sl.registerFactory<CourseBloc>(()=>CourseBloc(sl()));
  sl.registerFactory<BranchBloc>(()=>BranchBloc(sl(),sl()));
  sl.registerFactory<SemesterBloc>(()=>SemesterBloc(sl(),sl()));
  sl.registerFactory<AcademicBatchBloc>(()=>AcademicBatchBloc(sl(),sl()));
  sl.registerFactory<SubjectBloc>(()=>SubjectBloc(sl(),sl(),sl()));
  sl.registerFactory<TeacherBloc>(()=>TeacherBloc(sl(), sl()));
  sl.registerFactory<ClassBloc>(()=>ClassBloc(sl()));
  sl.registerFactory<CurrentSessionBloc>(()=>CurrentSessionBloc(repository: sl()));
  sl.registerFactory<AttendanceBloc>(()=>AttendanceBloc(attendanceRepository: sl()));
  sl.registerFactory<SettingBloc>(()=>SettingBloc(sl()));
}