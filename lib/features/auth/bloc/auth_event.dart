import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object?> get props => [];

}

class CheckAuthStatus extends AuthEvent{

}
class LogoutRequested extends AuthEvent{

}

class SendOtpEvent extends AuthEvent{
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends AuthEvent{
  final String verificationId;
  final String otp;
  const VerifyOtpEvent(this.verificationId,this.otp);
}
