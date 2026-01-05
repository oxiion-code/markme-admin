import 'package:equatable/equatable.dart';

class CurrentSessionEvent extends Equatable{
  const CurrentSessionEvent();
  @override
  List<Object?> get props => [];
}

class LoadClassSessionsEvent extends CurrentSessionEvent{
  final String collegeId;
  const LoadClassSessionsEvent({required this.collegeId});
  @override
  List<Object?> get props => [collegeId];
}
