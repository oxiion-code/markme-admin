import 'package:firebase_auth/firebase_auth.dart';
import 'package:markme_admin/features/auth/bloc/auth_event.dart';
import 'package:markme_admin/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';
import 'package:markme_admin/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckAuthStatus>(_checkAuthStatus);
    on<LogoutRequested>(_onLogoutRequest);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await authRepository.sendOtp(
      phoneNumber: event.phoneNumber,
      onCodeSent: (verificationId) {
        emit(OtpSent(verificationId));
      },
      onVerificationComplete: () {
        emit(
          AuthenticationSuccess(
            authInfo: AuthInfo(uid: '', phoneNumber: event.phoneNumber),
            isNewUser: false,
          ),
        );
      },
    );

    result.fold((failure) => emit(AuthError(failure.message)), (_) {});
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOtp(
      verificationId: event.verificationId,
      otp: event.otp,
    );
    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (authInfo) async {
        final userDataResult = await authRepository.getUserdata(
          uid: authInfo.uid,
        );
        userDataResult.fold(
          (failure) {
            emit(AuthenticationSuccess(authInfo: authInfo, isNewUser: true));
          },
          (adminUser) {
            emit(
              AuthenticationSuccess(
                authInfo: authInfo,
                isNewUser: false,
                adminUser: adminUser,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(UnAuthenticated());
      return;
    }
    final uid=currentUser.uid;
    final phoneNumber=currentUser.phoneNumber??"";
    final result = await authRepository.getUserdata(uid: currentUser.uid,);
    result.fold(
      (failure) {
        if(failure.message=='User does not exist'){
          final authInfo=AuthInfo(uid: uid, phoneNumber: phoneNumber);
          emit(UserIsNotRegistered(authInfo: authInfo));
        }else{
          emit(AuthError(failure.message));
        }
      },
      (adminUser) => emit(UserAlreadyLoggedIn(adminUser)),
    );
  }
  Future<void> _onLogoutRequest(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.logout();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
