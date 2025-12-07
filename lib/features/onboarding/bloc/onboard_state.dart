import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/onboarding/models/college_detail.dart';

import '../models/user_model.dart';

abstract class OnboardState extends Equatable{
  const OnboardState();
  @override
  List<Object?> get props =>[];
}
class OnboardInitial extends OnboardState{}
class OnboardLoading extends OnboardState{}
class OnboardSuccess extends OnboardState{
  final AdminUser user;
  const OnboardSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class OnboardError extends OnboardState{
  final String errorMessage;
  const OnboardError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
class LoadedAllColleges extends OnboardState{
  final List<CollegeDetail> collegeList;
  const LoadedAllColleges({required this.collegeList});
  @override
  List<Object?> get props => [collegeList];
}

class BannerImageUploaded extends OnboardState{
  final String bannerLink;
  const BannerImageUploaded({required this.bannerLink});
  @override
  List<Object?> get props => [bannerLink];
}