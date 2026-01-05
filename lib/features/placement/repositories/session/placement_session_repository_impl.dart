import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/session/placement_form.dart';
import 'package:markme_admin/features/placement/models/session/placement_session.dart';
import 'package:markme_admin/features/placement/repositories/session/placement_session_repository.dart';

import '../../models/session/session_attendance.dart';

class PlacementSessionRepositoryImpl extends PlacementSessionRepository {
  final FirebaseFirestore firestore;

  PlacementSessionRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, Unit>> addSession(PlacementSession session) async {
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
    PlacementSession session,
  ) async {
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
  Future<Either<AppFailure, PlacementSession>> loadPlacementSession(
    String collegeId,
    String sessionId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .doc(sessionId)
          .get();
      final data = snapshot.data()!;
      return Right(PlacementSession.fromJson(data));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<PlacementSession>>> loadLivePlacementSessions(
    String collegeId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .where('status', isEqualTo: 'live')
          .get();
      final sessions = snapshot.docs
          .map((s) => PlacementSession.fromJson(s.data()))
          .toList();
      return Right(sessions);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<PlacementForm>>> loadSessionApplications(
    String collegeId,
    String sessionId,
  ) async {
    try {
      final snapshot = await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .doc(sessionId)
          .collection("applications")
          .get();
      final applications = snapshot.docs.map(
        (application) => PlacementForm.fromMap(application.data()),
      ).toList();
      return Right(applications);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }



  @override
  Future<Either<AppFailure, Unit>> markAttendanceForSession(
      String collegeId,
      String sessionId,
      Map<String, bool> attendances,
      ) async {
    try {
      final attendanceId = "ATD-$sessionId";

      final attendanceRef = firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .doc(sessionId)
          .collection("attendances")
          .doc(attendanceId);

      final batch = firestore.batch();
      batch.set(
        attendanceRef,
        {
          'attendanceId': attendanceId,
          'sessionId': sessionId,
          'applicants': attendances,
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      await batch.commit();
      return right(unit);
    } catch (e) {
      return left(
        AppFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteAttendanceForSession(
      String collegeId,
      String sessionId,
      ) async {
    try {
      final attendanceId = "ATD-$sessionId";

      final attendanceRef = firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .doc(sessionId)
          .collection("attendances")
          .doc(attendanceId);

      await attendanceRef.delete();

      return right(unit);
    } catch (e) {
      return left(
        AppFailure(message:
          e.toString(),
        ),
      );
    }
  }
  @override
  Future<Either<AppFailure, SessionAttendanceModel?>> getAttendancesForSession(
      String collegeId,
      String sessionId,
      ) async {
    try {
      final attendanceId = "ATD-$sessionId";

      final docSnap = await firestore
          .collection("placement")
          .doc(collegeId)
          .collection("sessions")
          .doc(sessionId)
          .collection("attendances")
          .doc(attendanceId)
          .get();

      if (!docSnap.exists || docSnap.data() == null) {
        return right(null);
      }

      final attendance = SessionAttendanceModel.fromJson(
        docSnap.data()!,
      );
      return right(attendance);
    } catch (e) {
      return left(
        AppFailure(message:
          e.toString(),
        ),
      );
    }
  }
}
