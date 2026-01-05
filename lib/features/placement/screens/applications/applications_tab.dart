import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/session/session_bloc.dart';
import '../../blocs/session/session_state.dart';
import '../../blocs/session/session_event.dart';
import '../../models/session/placement_session.dart';
import '../../widgets/applications/placement_session_card.dart';


class ApplicationsTab extends StatefulWidget {
  final String collegeId;

  const ApplicationsTab({
    super.key,
    required this.collegeId,
  });

  @override
  State<ApplicationsTab> createState() => _ApplicationsTabState();
}

class _ApplicationsTabState extends State<ApplicationsTab> {
  @override
  void initState() {
    super.initState();

    context.read<PlacementSessionBloc>().add(
      LoadPlacementSessionsEvent(collegeId: widget.collegeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<PlacementSessionBloc, PlacementSessionState>(
        builder: (context, state) {
          if (state is PlacementSessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlacementSessionFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          /// ✅ Loaded
          if (state is AllPlacementSessionLoaded) {
            final List<PlacementSession> liveSessions =
                state.placementSessions;

            if (liveSessions.isEmpty) {
              return const Center(
                child: Text(
                  'No live placement sessions available',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80, top: 8),
              itemCount: liveSessions.length,
              itemBuilder: (context, index) {
                final session = liveSessions[index];
                return SessionCard(session: session,collegeId: widget.collegeId,);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
