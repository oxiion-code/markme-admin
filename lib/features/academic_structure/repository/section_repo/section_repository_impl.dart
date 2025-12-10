import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository.dart';

class SectionRepositoryImpl extends SectionRepository {
  final FirebaseFirestore _firestore;
  SectionRepositoryImpl(this._firestore);

  @override
  Future<Either<AppFailure, Unit>> addSection(Section section,String collegeId) async {
    try {
      await _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .doc(section.sectionId)
          .set(section.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteSection(Section section,String collegeId) async {
    try {
      await _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .doc(section.sectionId).delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Section>>> getAllSections(
    String branchId,
      String collegeId
  ) async {
    try {
      final snapshot = await _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .where("branchId", isEqualTo: branchId)
          .get();
      final sections = snapshot.docs
          .map((doc) => Section.fromMap(doc.data()))
          .toList();
      return Right(sections);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateSection(Section section,String collegeId) async {
    try {
      await _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .doc(section.sectionId)
          .update(section.toMap());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
