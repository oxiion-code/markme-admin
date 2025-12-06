import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/settings/bloc/setting_event.dart';
import 'package:markme_admin/features/settings/bloc/setting_state.dart';
import 'package:markme_admin/features/settings/repositoies/setting_repository.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRepository settingRepository;
  SettingBloc(this.settingRepository) : super(SettingInitial()) {
    on<UpdateProfileDataEvent>(_updateProfileDate);
  }

  FutureOr<void> _updateProfileDate(
    UpdateProfileDataEvent event,
    Emitter<SettingState> emit,
  ) async {
    try {
      emit(SettingLoading());
      final result = await settingRepository.updateProfileData(event.adminUser,event.profileImage);
      result.fold(
        (failure) => emit(SettingError(failure.message)),
        (adminData) => emit(UpdatedProfileData(adminData)),
      );
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }
}
