import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class SettingEvent extends Equatable{
  const SettingEvent();
  @override
  List<Object?> get props => [];
}
class UpdateProfileDataEvent extends SettingEvent{
  final AdminUser adminUser;
  final File? profileImage;
  const UpdateProfileDataEvent(this.adminUser, this.profileImage);
  @override
  List<Object?> get props => [adminUser];
}