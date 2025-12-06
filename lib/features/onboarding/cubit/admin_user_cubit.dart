
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class AdminUserCubit extends Cubit<AdminUser?> {
  AdminUserCubit():super(null);
  void setUser(AdminUser user){
    emit(user);
  }
  void updateUser(AdminUser updateUser){
    emit(updateUser);
  }
  void clearUser(){
    emit(null);
  }
}