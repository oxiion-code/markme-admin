import 'package:flutter/material.dart';

import '../../models/company/company.dart';


class CompanyInfoSection extends StatelessWidget {
  final Company company;

  const CompanyInfoSection({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(company.name),
        subtitle: Text(company.location),
      ),
    );
  }
}
