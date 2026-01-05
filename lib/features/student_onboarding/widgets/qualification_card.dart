import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/qualification.dart';

class QualificationCard extends StatelessWidget {
  final Qualification qualification;

  const QualificationCard({super.key,required this.qualification});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qualification.qualificationType,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            if (qualification.institutionName.trim().isNotEmpty) ...[
              _info('Institution', qualification.institutionName),
              _info('Board / University', qualification.boardOrUniversity),

              if (qualification.streamOrSpecialization != null &&
                  qualification.streamOrSpecialization!.trim().isNotEmpty)
                _info('Stream', qualification.streamOrSpecialization!),

              _info('Passing Year', qualification.passingOutYear.toString()),

              if (qualification.percentage != null)
                _info('Percentage', '${qualification.percentage}%'),

              const SizedBox(height: 8),
            ]
,
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('View Document'),
              onPressed: () {
               context.push( "/student-document",extra: qualification);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text('$label: $value'),
    );
  }
}
