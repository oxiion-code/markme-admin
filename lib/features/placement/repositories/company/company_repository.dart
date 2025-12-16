import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';

abstract class CompanyRepository{
  Future<Either<AppFailure,Unit>> addCompany(String collegeId,Company company,File? companyLogo);
  Future<Either<AppFailure,Unit>> updateCompany(String collegeId,Company company,File? companyLogo);
  Future<Either<AppFailure,Unit>> deleteCompany(String collegeId,Company company);
  Future<Either<AppFailure,List<Company>>> loadCompanies(String collegeId);
  Future<Either<AppFailure,Company>> fetchCompanyData(String collegeId, String companyId);
}