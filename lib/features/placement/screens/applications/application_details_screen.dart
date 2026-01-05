import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/features/placement/models/session/document_args.dart';
import '../../models/session/placement_form.dart';

class PlacementApplicationDetailsScreen extends StatelessWidget {
  final PlacementForm application;

  const PlacementApplicationDetailsScreen({
    super.key,
    required this.application,
  });

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Basic Information'),
            _infoTile('Student Name', application.studentName),
            _infoTile('Registration No', application.registrationNo),
            _infoTile('Batch Id', application.batchId.toUpperCase()),

            const SizedBox(height: 16),

            _sectionTitle('Job Information'),
            _infoTile('Company Name', application.companyName),
            _infoTile('Job Title', application.jobTitle),
            _infoTile('Session ID', application.sessionId),
            _infoTile('Application ID', application.applicationId),

            const SizedBox(height: 16),

            _sectionTitle('10th Details'),
            _infoTile('School', application.tenthCollegeName),
            _infoTile('Percentage / CGPA', application.tenthCgpaOrPercentage),
            _documentTile(
              context,
              '10th Certificate',
              application.tenthCertificateUrl,
            ),

            const SizedBox(height: 16),

            _sectionTitle('12th Details'),
            _infoTile('School', application.twelfthCollegeName),
            _infoTile('Percentage / CGPA', application.twelfthCgpaOrPercentage),
            _documentTile(
              context,
              '12th Certificate',
              application.twelfthCertificateUrl,
            ),

            const SizedBox(height: 16),

            _sectionTitle('Graduation Details'),
            _infoTile(
              'College',
              application.graduationCollegeName.isEmpty
                  ? 'Not Provided'
                  : application.graduationCollegeName,
            ),
            _infoTile(
              'CGPA / Percentage',
              application.graduationCgpaOrPercentage.isEmpty
                  ? 'Not Provided'
                  : application.graduationCgpaOrPercentage,
            ),
            _documentTile(
              context,
              'Graduation Certificate',
              application.graduationCertificateUrl,
            ),

            const SizedBox(height: 16),

            _sectionTitle('Masters Details'),
            _infoTile(
              'College',
              application.mastersCollegeName.isEmpty
                  ? 'Not Provided'
                  : application.mastersCollegeName,
            ),
            _infoTile(
              'CGPA / Percentage',
              application.mastersCgpaOrPercentage.isEmpty
                  ? 'Not Provided'
                  : application.mastersCgpaOrPercentage,
            ),
            _documentTile(
              context,
              'Masters Certificate',
              application.mastersCertificateUrl,
            ),

            const SizedBox(height: 16),

            _sectionTitle('Undertaking'),
            _infoTile(
              'Description',
              application.undertakingDescription,
            ),
            _infoTile(
              'Date',
              formatDate(application.undertakingDate),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _infoTile(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(value.isEmpty ? '-' : value),
        ),
      ],
    ),
  );
}

Widget _documentTile(
    BuildContext context,
    String title,
    String url,
    ) {
  if (url.isEmpty) {
    return _infoTile(title, 'Not Uploaded');
  }

  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    trailing: const Icon(Icons.picture_as_pdf),
    onTap: () {
      final args=DocumentArgs(url: url, title: title);
      context.push('/document',extra: args);
    },
  );
}
