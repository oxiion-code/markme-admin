import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

abstract class OnboardEvent extends Equatable{
  const OnboardEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubmitPersonalInfoEvent extends OnboardEvent{
  final AdminUser user;
  final File? profileImage;
  final bool isSuperAdmin;
  const SubmitPersonalInfoEvent({required this.user,required this.profileImage, required this.isSuperAdmin});
  @override
  List<Object?> get props => [user,profileImage,isSuperAdmin];
}