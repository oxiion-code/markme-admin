import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/college_detail.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/onboarding/repository/onboard_repository.dart';

class OnboardRepositoryImpl extends OnboardRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  OnboardRepositoryImpl(this.firestore, this.storage);
  // to create user
  @override
  Future<Either<AppFailure, AdminUser>> createUser({
    required AdminUser user,
    required File pickedImage,
    required bool isSuperAdmin,
  }) async {
    try {
      final collegeId = user.collegeId;
      final uid = user.uid;

      final collegeRef = firestore.collection('collegeList').doc(collegeId);
      final userRef = firestore.collection('admins').doc(uid);

      final collegeSnapshot = await collegeRef.get();

      bool superAdminExists =
          collegeSnapshot.exists &&
          (collegeSnapshot.data()?['isSuperAdminExist'] ?? false);

      if (isSuperAdmin && superAdminExists) {
        return Left(AppFailure(message: 'Super admin already exists'));
      }
      await collegeRef.set({
        'collegeName': user.collegeName,
        if (!superAdminExists && isSuperAdmin)
          'isSuperAdminExist': isSuperAdmin,
        if (user.bannerLink != null) 'bannerLink': user.bannerLink,
      }, SetOptions(merge: true));
      final downloadUrl = await uploadProfileImage(pickedImage, user.uid);
      if (downloadUrl != null) {
        final userWithPhoto = user.copyWith(profilePhotoUrl: downloadUrl);
        await userRef.set(userWithPhoto.toMap());
        return Right(userWithPhoto);
      } else {
        return Left(AppFailure(message: 'Failed to upload image'));
      }
    } on FirebaseException catch (e) {
      return Left(AppFailure(message: e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(AppFailure(message: 'unknown error occurred: $e'));
    }
  }

  // to get user data
  @override
  Future<Either<AppFailure, AdminUser>> getUserdata({required String uid}) {
    // TODO: implement getUserdata
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadProfileImage(File imageFile, String uid) async {
    try {
      final ref = storage.ref().child('profileImage/$uid.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error in uploading image:$e');
      return null;
    }
  }

  @override
  Future<Either<AppFailure, List<CollegeDetail>>> loadAllColleges() async {
    try {
      final snapshot = await firestore.collection('collegeList').get();
      final colleges = snapshot.docs.map((doc) {
        final data = doc.data();
        return CollegeDetail.fromMap({...data, 'id': doc.id});
      }).toList();
      return Right(colleges);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, String>> uploadCollegeBanner({
    required String collegeId,
    required File file,
  }) async {
    try {
      final ref = storage.ref().child("college_banners/$collegeId/banner.png");
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
