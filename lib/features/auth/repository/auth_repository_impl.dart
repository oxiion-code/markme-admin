import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';

import '../../onboarding/models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  const AuthRepositoryImpl(this._firebaseAuth);
  @override
  Future<Either<AppFailure, void>> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function() onVerificationComplete,
  }) async {
    final completer = Completer<Either<AppFailure, void>>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _firebaseAuth.signInWithCredential(credential);
          onVerificationComplete();
          completer.complete(const Right(null));
        } catch (e) {
          completer.complete(Left(AppFailure(message: e.toString())));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.complete(Left(AppFailure(message: e.message ?? "OTP send failed")));
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }


  @override
  Future<Either<AppFailure,AuthInfo>> verifyOtp({required String verificationId,required String otp}) async{
    try{
      final credential =PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
     await _firebaseAuth.signInWithCredential(credential);
     if(_firebaseAuth.currentUser ==null){
       return Left(AppFailure(message: 'No current user'));
      }
     final uid= _firebaseAuth.currentUser!.uid;
     final phoneNumber=_firebaseAuth.currentUser!.phoneNumber;
     return Right(AuthInfo(uid: uid,phoneNumber:phoneNumber!));
    }catch(e){
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, AdminUser>> getUserdata({required String uid}) async {
   try{
     final doc=await FirebaseFirestore.instance.collection('admins').doc(uid).get();
     if(!doc.exists){
       return Left(AppFailure(message: 'User does not exist'));
     }
     final userData=doc.data()!;
     final user=AdminUser.fromMap(userData);
     return Right(user);
   }catch(e){
     return Left(AppFailure(message: e.toString()));
   }
  }

  @override
  Future<Either<AppFailure, void>> logout() async{
    try{
      await _firebaseAuth.signOut();
      return Right(null);
    }catch(e){
      return left(AppFailure(message: 'Logout failed:${e.toString()}'));
    }
  }
}
