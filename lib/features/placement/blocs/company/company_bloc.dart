import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';
import 'package:markme_admin/features/placement/repositories/company/company_repository.dart';
import 'company_event.dart';
import 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository repository;

  CompanyBloc({required this.repository}) : super(CompanyInitial()) {
    // Load companies
    on<LoadCompanies>(_onLoadCompanies);

    // Add company
    on<AddCompany>(_onAddCompany);

    // Update company
    on<UpdateCompany>(_onUpdateCompany);

    // Delete company
    on<DeleteCompany>(_onDeleteCompany);
  }

  // ---------------- Load Companies ----------------
  Future<void> _onLoadCompanies(
    LoadCompanies event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await repository.loadCompanies(event.collegeId);

    result.fold(
      (failure) => emit(CompanyOperationFailure(failure.message)),
      (companies) => emit(CompaniesLoaded(companies)),
    );
  }

  // ---------------- Add Company ----------------
  Future<void> _onAddCompany(
    AddCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await repository.addCompany(
      event.collegeId,
      event.company,
      event.companyLogo,
    );

    result.fold(
      (failure) => emit(CompanyOperationFailure(failure.message)),
      (_) => emit(CompanyAdded()),
    );
  }

  Future<void> _onUpdateCompany(
    UpdateCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await repository.updateCompany(
      event.collegeId,
      event.company,
      event.companyLogo,
    );

    result.fold(
      (failure) => emit(CompanyOperationFailure(failure.message)),
      (_) => emit(CompanyUpdated()),
    );
  }

  Future<void> _onDeleteCompany(
    DeleteCompany event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    final result = await repository.deleteCompany(
      event.collegeId,
      event.company,
    );

    result.fold(
      (failure) => emit(CompanyOperationFailure(failure.message)),
      (_) => emit(CompanyDeleted()),
    );
  }
}
