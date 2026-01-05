import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/college_detail.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/settings/models/class_schedule.dart';
import 'package:markme_admin/features/settings/repositoies/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  SettingRepositoryImpl(this.firestore, this.storage);
  @override
  Future<Either<AppFailure, AdminUser>> updateProfileData(
    AdminUser adminUser,
    File? profileImage,
  ) async {
    try {
      String? imageUrl;
      if (profileImage != null) {
        final ref = storage.ref().child('profileImage/${adminUser.uid}.jpeg');
        await ref.putFile(profileImage);
        imageUrl = await ref.getDownloadURL();
      }
      final updatedData = {
        'name': adminUser.name,
        'email': adminUser.email,
        if (imageUrl != null) 'profilePhotoUrl': imageUrl,
      };

      await firestore
          .collection('admins')
          .doc(adminUser.uid)
          .update(updatedData);
      final updatedAdminUser = adminUser.copyWith(
        profilePhotoUrl: imageUrl ?? adminUser.profilePhotoUrl,
      );
      return Right(updatedAdminUser);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> uploadCollegeSchedule(
      String collegeId,
      CollegeSchedule collegeSchedule,
      ) async {
    try {

      final docRef = FirebaseFirestore.instance
          .collection('collegeList')
          .doc(collegeId);

      /// update only classSchedule field
      await docRef.update({
        'collegeSchedule': collegeSchedule.toMap(),
      });
      return Right(unit);
    } catch (e) {
      return Left(
        AppFailure(
          message: e.toString(),
        ),
      );
    }
  }
  @override
  Future<Either<AppFailure, CollegeDetail>> getCollegeDetails(
      String collegeId,
      ) async {
    try {
      final doc = await firestore
          .collection('collegeList')
          .doc(collegeId)
          .get();
      if (!doc.exists) {
        return Left(
          AppFailure(message: 'College not found'),
        );
      }
      final collegeDetail = CollegeDetail.fromMap(doc.data()!);
      return Right(collegeDetail);
    } catch (e) {
      return Left(
        AppFailure(
          message: 'Failed to fetch college details',
        ),
      );
    }
  }
}
