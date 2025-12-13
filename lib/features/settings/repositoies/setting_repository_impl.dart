import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/settings/repositoies/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository{
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  SettingRepositoryImpl(this.firestore,this.storage);
  @override
  Future<Either<AppFailure, AdminUser>> updateProfileData(AdminUser adminUser, File? profileImage)async {
    try{
      String? imageUrl;
      if(profileImage!=null){
        final ref= storage.ref().child('profileImage/${adminUser.uid}.jpeg');
        await ref.putFile(profileImage);
        imageUrl= await ref.getDownloadURL();
      }
      final updatedData= {
        'name':adminUser.name,
        'email':adminUser.email,
        if(imageUrl!=null) 'profilePhotoUrl':imageUrl
      };

      await firestore.collection('admins').doc(adminUser.uid).update(updatedData);
      final updatedAdminUser= adminUser.copyWith(
          profilePhotoUrl: imageUrl??adminUser.profilePhotoUrl
      );
      return Right(updatedAdminUser);
    }catch(e){
      return Left(AppFailure(message: e.toString()));
    }
  }

}