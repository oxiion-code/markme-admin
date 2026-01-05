import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:markme_admin/features/classes/repository/class_repository.dart';


import 'current_session_event.dart';
import 'current_session_state.dart';



class CurrentSessionBloc extends Bloc<CurrentSessionEvent, CurrentClassSessionState> {
  final ClassRepository repository;
  StreamSubscription? _sessionSubscription;

  CurrentSessionBloc({required this.repository}) : super(CurrentSessionInitial()) {
    on<LoadClassSessionsEvent>(_onLoadSessions);
  }
  Future<void> _onLoadSessions(
      LoadClassSessionsEvent event, Emitter<CurrentClassSessionState> emit) async {
    emit(CurrentSessionLoading());

    await emit.forEach(
      repository.getCurrentDayClasses(event.collegeId),
      onData: (either) => either.fold(
            (failure) => CurrentSessionFailed(message: failure.message),
            (sessions) {
          final live = sessions.where((s) => s.status == 'live').toList();
          final ended = sessions.where((s) => s.status == 'ended').toList();
          return LoadedCurrentClassSessions(
            liveSessions: live,
            pastSessions: ended,
          );
        },
      ),
      onError: (error, stackTrace) => CurrentSessionFailed(message: error.toString()),
    );
  }
  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}
