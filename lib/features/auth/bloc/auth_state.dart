import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String verificationId;

  const OtpSent(this.verificationId);
  @override
  // TODO: implement props
  List<Object?> get props => [verificationId];
}

class AuthenticationSuccess extends AuthState {
  final AuthInfo authInfo;
  final bool isNewUser;
  final AdminUser? adminUser;
  const AuthenticationSuccess({required this.authInfo,required this.isNewUser,this.adminUser});

  @override
  List<Object?> get props => [authInfo,isNewUser,adminUser];
}

class UserAlreadyLoggedIn extends AuthState{
  final AdminUser adminUser;
  const UserAlreadyLoggedIn(this.adminUser);

  @override
  List<Object?> get props => [adminUser];
}
class UserIsNotRegistered extends AuthState{
  final AuthInfo authInfo;
  const UserIsNotRegistered({required this.authInfo});
  @override
  List<Object?> get props => [authInfo];
}

class UnAuthenticated extends AuthState{

}

class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);

  @override
  List<Object?> get props => [error];
}
class LogoutSuccess extends AuthState{

}
