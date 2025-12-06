import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/onboarding/repository/onboard_repository.dart';

class OnboardRepositoryImpl extends OnboardRepository {
  final FirebaseFirestore firestore;
  OnboardRepositoryImpl(this.firestore);
  // to create user
  @override
  Future<Either<AppFailure, AdminUser>> createUser({
    required AdminUser user,
    required File pickedImage,
    required bool isSuperAdmin,
  }) async {
    try{
      final collegeId=user.collegeId;
      final uid=user.uid;

      final collegeRef=firestore.collection('collegeList').doc(collegeId);
      final userRef=firestore.collection('users').doc(uid);

      final collegeSnapshot=await collegeRef.get();

      bool superAdminExists=collegeSnapshot.exists && (collegeSnapshot.data()?['isSuperAdminExist']??false);

      if(isSuperAdmin && superAdminExists){
        return Left(AppFailure(message: 'Super admin already exists'));
      }
      await collegeRef.set({
        'collegeName':user.collegeName,
        if(!superAdminExists && isSuperAdmin)'isSuperAdminExist':isSuperAdmin
      },SetOptions(merge: true));
      final downloadUrl=await uploadProfileImage(pickedImage, user.uid);
      if(downloadUrl!=null){
        final userWithPhoto=user.copyWith(profilePhotoUrl: downloadUrl);
        await userRef.set(userWithPhoto.toMap());
        return  Right(userWithPhoto);
      }else{
        return Left(AppFailure(message: 'Failed to upload image'));
      }
    }on FirebaseException catch(e){
      return Left(AppFailure( message: e.message??'Firestore error'));
    }
    catch(e){
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
  Future<String?> uploadProfileImage(File imageFile, String uid) async{
    try{
      final ref=FirebaseStorage.instance.ref().child('profileImage/$uid.jpg');
      await ref.putFile(imageFile);
      final url=await ref.getDownloadURL();
      return url;
    }catch(e){
      print('Error in uploading image:$e');
      return null;
    }
  }
}
