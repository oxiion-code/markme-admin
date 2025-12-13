import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object?> get props => [];
}

// Load companies
class LoadCompanies extends CompanyEvent {
  final String collegeId;
  const LoadCompanies(this.collegeId);

  @override
  List<Object?> get props => [collegeId];
}

// Add company
class AddCompany extends CompanyEvent {
  final String collegeId;
  final Company company;
  final File? companyLogo;

  const AddCompany({
    required this.collegeId,
    required this.company,
    this.companyLogo,
  });

  @override
  List<Object?> get props => [collegeId, company, companyLogo];
}

// Update company
class UpdateCompany extends CompanyEvent {
  final String collegeId;
  final Company company;
  final File? companyLogo;

  const UpdateCompany({
    required this.collegeId,
    required this.company,
    this.companyLogo,
  });

  @override
  List<Object?> get props => [collegeId, company, companyLogo];
}

// Delete company
class DeleteCompany extends CompanyEvent {
  final String collegeId;
  final Company company;

  const DeleteCompany({
    required this.collegeId,
    required this.company,
  });

  @override
  List<Object?> get props => [collegeId, company];
}
