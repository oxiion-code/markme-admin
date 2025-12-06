import 'package:dartz/dartz.dart';
import 'package:markme_admin/features/classes/models/class_session.dart';

import '../../../core/error/failure.dart';
import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../../academic_structure/models/course.dart';
import '../models/class_info.dart';

abstract class ClassRepository {
  Future<Either<AppFailure, Unit>> addClass(ClassInfo classInfo);
  Future<Either<AppFailure, Unit>> updateClass(ClassInfo classInfo);
  Future<Either<AppFailure, Unit>> deleteClass(String classId);
  Future<Either<AppFailure, List<ClassInfo>>> getAllClasses();
  Future<Either<AppFailure, List<ClassInfo>>> getClassesForTeacher(String teacherId);
  Stream<Either<AppFailure,List<ClassSession>>> getCurrentDayClasses();

  // Dropdown data
  Future<Either<AppFailure, List<Course>>> getAllCourses();
  Future<Either<AppFailure, List<Branch>>> getBranchesForCourse(String courseId);
  Future<Either<AppFailure, List<AcademicBatch>>> getBatchesForBranch(String branchId);
}
