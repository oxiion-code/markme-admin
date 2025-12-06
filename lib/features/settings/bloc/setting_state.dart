import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class SettingState extends Equatable{
  const SettingState();
  @override
  List<Object?> get props => [];
}
class SettingInitial extends SettingState{

}
class SettingLoading extends SettingState{

}
class UpdatedProfileData extends SettingState{
  final AdminUser adminData;
  const UpdatedProfileData(this.adminData);
  @override
  List<Object?> get props => [adminData];
}

class SettingError extends SettingState{
  final String message;
  const SettingError(this.message);
  @override
  List<Object?> get props => [message];
}