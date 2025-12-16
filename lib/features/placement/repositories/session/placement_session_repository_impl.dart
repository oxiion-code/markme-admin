import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/placement_form.dart';
import 'package:markme_admin/features/placement/models/session/placement_session.dart';
import 'package:markme_admin/features/placement/repositories/session/placement_session_repository.dart';

class PlacementSessionRepositoryImpl extends PlacementSessionRepository {
  final FirebaseFirestore firestore;

  PlacementSessionRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, Unit>> addSession(
      PlacementSession session,
      ) async {
    try {
      final batch = firestore.batch();

      // 1️⃣ Add session document
      final sessionRef = firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("sessions")
          .doc(session.sessionId);

      batch.set(sessionRef, session.toJson());

      // 2️⃣ Update company -> add sessionId to array
      final companyRef = firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("companies")
          .doc(session.companyId);

      batch.update(companyRef, {
        "sessionIds": FieldValue.arrayUnion([session.sessionId]),
      });

      // 3️⃣ Commit batch
      await batch.commit();

      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteSession(
      PlacementSession session,
      ) async {
    try {
      final batch = firestore.batch();

      // 1️⃣ Delete session document
      final sessionRef = firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("sessions")
          .doc(session.sessionId);

      batch.delete(sessionRef);

      // 2️⃣ Remove sessionId from company.sessionIds
      final companyRef = firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("companies")
          .doc(session.companyId);

      batch.update(companyRef, {
        "sessionIds": FieldValue.arrayRemove([session.sessionId]),
      });
      await batch.commit();
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateSession(
      PlacementSession session,) async {
    try {
      await firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("sessions")
          .doc(session.sessionId)
          .update(session.toJson());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, PlacementSession>> loadPlacementSession(String collegeId, String sessionId) async{
    try {
     final snapshot= await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .doc(sessionId)
          .get();
     final data= snapshot.data()!;
      return Right(PlacementSession.fromJson(data));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
