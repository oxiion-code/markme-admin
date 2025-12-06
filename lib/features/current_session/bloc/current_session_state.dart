import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/classes/models/class_session.dart';

class CurrentClassSessionState extends Equatable{
  const CurrentClassSessionState();
  @override
  List<Object?> get props => [];
}

class CurrentSessionLoading extends CurrentClassSessionState{

}
class CurrentSessionInitial extends CurrentClassSessionState{

}
class CurrentSessionFailed extends CurrentClassSessionState{
  final String message;
  const CurrentSessionFailed({required this.message});
  @override
  List<Object?> get props => [message];
}
class LoadedCurrentClassSessions extends CurrentClassSessionState{
  final List<ClassSession> liveSessions;
  final List<ClassSession> pastSessions;
  const LoadedCurrentClassSessions({required this.liveSessions, required this.pastSessions});
  @override
  List<Object?> get props => [liveSessions,pastSessions];
}