import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/college_detail.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

abstract class OnboardRepository{
  Future<Either<AppFailure,AdminUser>> createUser({required AdminUser user,required File pickedImage, required bool isSuperAdmin});
  Future<Either<AppFailure,AdminUser>> getUserdata({required String uid});
  Future<String?> uploadProfileImage(File imageFile,String uid);
  Future<Either<AppFailure,List<CollegeDetail>>> loadAllColleges();
  Future<Either<AppFailure,String>> uploadCollegeBanner({required String collegeId,required File file});
}