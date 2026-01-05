import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/features/placement/models/session/application_args.dart';

import '../../models/session/placement_session.dart';

class SessionCard extends StatelessWidget {
  final PlacementSession session;
  final String collegeId;
  const SessionCard({super.key,required this.session, required this.collegeId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              session.companyName.isNotEmpty
                  ? session.companyName[0]
                  : '?',
              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue, fontSize: 22),
            ),
          ),
          title: Text(
            session.companyName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(session.role),
              const SizedBox(height: 2),
              Text(
                'Status: LIVE',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            final args=ApplicationArgs(placementSession: session, collegeId:collegeId);
            context.push("/sessionApplications",extra: args);
          },
        ),
      ),
    );
  }
}

