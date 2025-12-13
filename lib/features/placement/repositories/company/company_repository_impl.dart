import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';
import 'package:markme_admin/features/placement/repositories/company/company_repository.dart';

class CompanyRepositoryImpl extends CompanyRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  CompanyRepositoryImpl({required this.firestore, required this.storage});
  @override
  Future<Either<AppFailure, Unit>> addCompany(
      String collegeId,
      Company company,
      File? companyLogo,
      ) async {
    try {
      String? logoUrl;

      // Upload logo if provided
      if (companyLogo != null) {
        final uploadResult = await uploadCompanyLogo(
          collegeId: collegeId,
          companyId: company.companyId,
          logoFile: companyLogo,
        );
        final url = uploadResult.fold(
              (failure) => null,
              (url) => url,
        );
        if (url == null) {
          return Left(AppFailure(message: "Failed to upload company logo"));
        }
        logoUrl = url;
      }
      final newCompany =
      logoUrl != null ? company.copyWith(logoUrl: logoUrl) : company;

      await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("companies")
          .doc(company.companyId)
          .set(newCompany.toMap());

      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteCompany(
      String collegeId,
      Company company,
      ) async {
    try {
      // Delete logo from storage if exists
      if (company.logoUrl != null && company.logoUrl!.isNotEmpty) {
        await deleteCompanyLogo(collegeId, company.companyId);
      }

      // Delete Firestore doc
      await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("companies")
          .doc(company.companyId)
          .delete();

      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<AppFailure, List<Company>>> loadCompanies(
      String collegeId,
      ) async {
    try {
      final snapshot = await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("companies")
          .get();

      final companies =
      snapshot.docs.map((doc) => Company.fromMap(doc.data())).toList();

      return Right(companies);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<AppFailure, Unit>> updateCompany(
      String collegeId,
      Company company,
      File? companyLogo,
      ) async {
    try {
      String? logoUrl;

      // Upload new logo if provided
      if (companyLogo != null) {
        final uploadResult = await uploadCompanyLogo(
          collegeId: collegeId,
          companyId: company.companyId,
          logoFile: companyLogo,
        );

        final url = uploadResult.fold(
              (failure) => null,
              (url) => url,
        );

        if (url == null) {
          return Left(AppFailure(message: "Failed to upload company logo"));
        }
        logoUrl = url;
      }

      final updatedCompany =
      logoUrl != null ? company.copyWith(logoUrl: logoUrl) : company;

      await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("companies")
          .doc(company.companyId)
          .update(updatedCompany.toMap());

      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
  Future<Either<AppFailure, String>> uploadCompanyLogo({
    required String collegeId,
    required String companyId,
    required File logoFile,
  }) async {
    try {
      final storageRef = storage.ref().child(
        "placement/$collegeId/companies/$companyId/logo.png",
      );

      await storageRef.putFile(logoFile);

      final downloadUrl = await storageRef.getDownloadURL();

      return Right(downloadUrl);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
  Future<void> deleteCompanyLogo(
      String collegeId,
      String companyId,
      ) async {
    final storageRef = storage.ref().child(
      "placement/$collegeId/companies/$companyId/logo.png",
    );

    try {
      await storageRef.delete();
    } catch (_) {
    }
  }
}
