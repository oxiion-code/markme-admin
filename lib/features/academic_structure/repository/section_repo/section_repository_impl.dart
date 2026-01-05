import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository.dart';

class SectionRepositoryImpl extends SectionRepository {
  final FirebaseFirestore _firestore;
  SectionRepositoryImpl(this._firestore);

  @override
  Future<Either<AppFailure, Unit>> addSection(
    Section section,
    String collegeId,
  ) async {
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
  Future<Either<AppFailure, Unit>> deleteSection(
    Section section,
    String collegeId,
  ) async {
    try {
      await _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .doc(section.sectionId)
          .delete();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Section>>> getAllSections(
    String branchId,
    String collegeId,
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
  Future<Either<AppFailure, Unit>> updateSection(
    Section section,
    String collegeId,
  ) async {
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

  @override
  Future<Either<AppFailure, List<Section>>> getAllSectionsForStudent(
    String branchId,
    String collegeId,
    String batchId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .where("branchId", isEqualTo: branchId).where("batchId",isEqualTo: batchId)
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
  Future<Either<AppFailure, Unit>> promoteSection(
      String collegeId,
      String sectionId,
      String currentSemesterId,
      int currentSemNumber,
      ) async {
    try {
      final int promotedSemNumber = currentSemNumber + 1;
      final parts = currentSemesterId.split('_'); // [bba, sem, 01]

      if (parts.length < 3) {
        return left(AppFailure(message: 'Invalid semester ID format'));
      }

      final String newSemNo =
      promotedSemNumber.toString().padLeft(2, '0');

      final String promotedSemesterId =
          '${parts[0]}_${parts[1]}_$newSemNo';

      /// 3️⃣ Check if promoted semester exists
      final promotedSemesterRef = _firestore
          .collection('semesters')
          .doc(collegeId)
          .collection('semesters')
          .doc(promotedSemesterId);

      final promotedSnapshot = await promotedSemesterRef.get();

      if (!promotedSnapshot.exists) {
        return left(
          AppFailure(
            message:
            'Promoted semester does not exist. Please create semester first.',
          ),
        );
      }

      /// 4️⃣ Update section document
      final sectionRef = _firestore
          .collection('sections')
          .doc(collegeId)
          .collection('sections')
          .doc(sectionId);

      await sectionRef.update({
        'currentSemesterId': promotedSemesterId,
        'currentSemesterNumber': promotedSemNumber,
      });

      return right(unit);
    } catch (e) {
      return left(
        AppFailure(
          message: e.toString(),
        ),
      );
    }
  }

}
