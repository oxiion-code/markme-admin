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
  Future<Either<AppFailure, Unit>> addSession(PlacementSession session) async {
    try {
      await firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("sessions")
          .doc(session.sessionId)
          .set(session.toJson());
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<AppFailure, Unit>> deleteSession(
      PlacementSession session,) async {
    try {
      await firestore
          .collection("placement")
          .doc(session.collegeId)
          .collection("sessions")
          .doc(session.sessionId)
          .delete();
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
}
