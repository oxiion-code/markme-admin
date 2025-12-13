import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

// Initial state
class CompanyInitial extends CompanyState {}

// Loading state
class CompanyLoading extends CompanyState {}

// Loaded companies
class CompaniesLoaded extends CompanyState {
  final List<Company> companies;

  const CompaniesLoaded(this.companies);

  @override
  List<Object?> get props => [companies];
}

// Operation success
class CompanyAdded extends CompanyState {}
class CompanyDeleted extends CompanyState {}
class CompanyUpdated extends CompanyState {}

// Operation failure
class CompanyOperationFailure extends CompanyState {
  final String message;

  const CompanyOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
