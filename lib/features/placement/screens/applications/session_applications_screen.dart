import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/features/placement/models/session/placement_form.dart';

import '../../blocs/session/session_bloc.dart';
import '../../blocs/session/session_event.dart';
import '../../blocs/session/session_state.dart';
import '../../models/session/placement_session.dart';

class PlacementSessionApplicationsScreen extends StatefulWidget {
  final String collegeId;
  final PlacementSession session;

  const PlacementSessionApplicationsScreen({
    super.key,
    required this.collegeId,
    required this.session,
  });

  @override
  State<PlacementSessionApplicationsScreen> createState() =>
      _PlacementSessionApplicationsScreenState();
}

class _PlacementSessionApplicationsScreenState
    extends State<PlacementSessionApplicationsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PlacementSessionBloc>().add(
      LoadSessionApplicationsEvent(
        collegeId: widget.collegeId,
        sessionId: widget.session.sessionId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session applications'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
      final state = context.read<PlacementSessionBloc>().state;
      if (state is ApplicationsLoadedForSession) {
        context.push(
          '/take-attendance',
          extra: {
            'collegeId': widget.collegeId,
            'session': widget.session,
            'applications': state.placementForms,
          },
        );
      }
    },
    icon: const Icon(Icons.how_to_reg_rounded),
    label: const Text('Take attendance'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _SessionInfoCard(session: session),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Text(
                  'Applications',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BlocBuilder<PlacementSessionBloc, PlacementSessionState>(
                    buildWhen: (prev, curr) =>
                    curr is ApplicationsLoadedForSession,
                    builder: (context, state) {
                      int count = 0;
                      if (state is ApplicationsLoadedForSession) {
                        count = state.placementForms.length;
                      }
                      return Text(
                        '$count students',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                        textAlign: TextAlign.right,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _ApplicationsList()),
        ],
      ),
    );
  }
}

class _SessionInfoCard extends StatelessWidget {
  final PlacementSession session;

  const _SessionInfoCard({required this.session});

  Color _statusColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  String _statusText() {
    return session.status.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: company + status chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    session.companyName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(
                    Icons.circle,
                    size: 14,
                    color: _statusColor(context),
                  ),
                  label: Text(
                    _statusText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _statusColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: _statusColor(context).withOpacity(0.08),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              session.role,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.cases_rounded,
                    size: 18, color: theme.hintColor),
                const SizedBox(width: 6),
                Text(
                  session.driveType,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range_outlined,
                    size: 18, color: theme.hintColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${_formatDate(session.startDate)}  •  ${_formatDate(session.endDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacementSessionBloc, PlacementSessionState>(
      builder: (context, state) {
        if (state is PlacementSessionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlacementSessionFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is ApplicationsLoadedForSession) {
          final applications = state.placementForms;

          if (applications.isEmpty) {
            return const Center(
              child: Text('No applications found yet'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
            itemCount: applications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final app = applications[index];
              return _ApplicationTile(application: app, index: index + 1);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  final PlacementForm application;
  final int index;

  const _ApplicationTile({
    required this.application,
    required this.index,
  });

  String _initials(String? name) {
    final n = (name ?? '').trim();
    if (n.isEmpty) return '?';
    final parts = n.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = application.studentName ?? 'Student';
    final regNo = application.registrationNo ?? '-';

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push("/application-details",extra: application);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                theme.colorScheme.primary.withOpacity(0.12),
                child: Text(
                  _initials(name),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Reg no: $regNo',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                visualDensity: VisualDensity.compact,
                label: const Text('Applied'),
                backgroundColor:
                theme.colorScheme.primary.withOpacity(0.08),
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year.toString();
  return '$d/$m/$y';
}
