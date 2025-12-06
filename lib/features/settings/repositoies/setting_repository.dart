import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

abstract class SettingRepository {
  Future<Either<AppFailure,AdminUser>> updateProfileData(AdminUser adminUser, File? profileImage);
}