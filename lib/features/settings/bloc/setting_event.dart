import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/settings/models/class_schedule.dart';

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
class LoadCollegeDetailEvent extends SettingEvent{
  final String collegeId;
  const LoadCollegeDetailEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
class UploadCollegeScheduleEvent extends SettingEvent{
  final String collegeId;
  final CollegeSchedule collegeSchedule;
  const UploadCollegeScheduleEvent({required this.collegeId, required this.collegeSchedule});
  @override
  List<Object?> get props => [collegeSchedule,collegeId];
}