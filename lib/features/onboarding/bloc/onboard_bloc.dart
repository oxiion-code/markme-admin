import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_event.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_state.dart';
import 'package:markme_admin/features/onboarding/repository/onboard_repository.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  final OnboardRepository onboardRepository;
  OnboardBloc(this.onboardRepository) : super(OnboardInitial()) {
    on<SubmitPersonalInfoEvent>(_savePersonalInfo);
    on<LoadAllClassesEvent>(_loadAllClasses);
    on<UploadBannerImageEvent>(_uploadBannerImage);
  }
  Future<void> _savePersonalInfo(
    SubmitPersonalInfoEvent event,
    Emitter<OnboardState> emit,
  ) async {
    emit(OnboardLoading());
    final result = await onboardRepository.createUser(
      user: event.user,
      pickedImage: event.profileImage!,
      isSuperAdmin: event.isSuperAdmin,
    );

    result.fold(
      (failure) {
        emit(OnboardError(failure.message));
      },
      (adminUser) {
        emit(OnboardSuccess(adminUser));
      },
    );
  }

  FutureOr<void> _loadAllClasses(
    LoadAllClassesEvent event,
    Emitter<OnboardState> emit,
  ) async {
    emit(OnboardLoading());
    final result = await onboardRepository.loadAllColleges();
    result.fold(
      (failure) {
        emit(OnboardError(failure.message));
      },
      (collegeList) {
        emit(LoadedAllColleges(collegeList: collegeList));
      },
    );
  }

  FutureOr<void> _uploadBannerImage(
    UploadBannerImageEvent event,
    Emitter<OnboardState> emit,
  ) async {
    emit(OnboardLoading());
    final result = await onboardRepository.uploadCollegeBanner(
      file: event.bannerImage!,
      collegeId: event.collegeUid,
    );
    result.fold(
      (failure) {
        emit(OnboardError(failure.message));
      },
      (url) {
        emit(BannerImageUploaded(bannerLink: url));
      },
    );
  }
}
