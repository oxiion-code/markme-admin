import 'package:equatable/equatable.dart';

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