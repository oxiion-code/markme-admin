import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';

import '../../onboarding/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<AppFailure,void>> sendOtp({
  required String phoneNumber,
  required void Function(String verificationId) onCodeSent,
  required void Function() onVerificationComplete
});
  Future<Either<AppFailure,AuthInfo>> verifyOtp({required String verificationId,required String otp});
  Future<Either<AppFailure, AdminUser>> getUserdata({required String uid});
  Future<Either<AppFailure, void>> logout();
}
