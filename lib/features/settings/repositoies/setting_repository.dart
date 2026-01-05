import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/college_detail.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/settings/models/class_schedule.dart';

abstract class SettingRepository {
  Future<Either<AppFailure, AdminUser>> updateProfileData(
    AdminUser adminUser,
    File? profileImage,
  );
  Future<Either<AppFailure, Unit>> uploadCollegeSchedule(
    String collegeId,
    CollegeSchedule collegeSchedule,
  );
  Future<Either<AppFailure, CollegeDetail>>getCollegeDetails(
      String collegeId,
      );
}
