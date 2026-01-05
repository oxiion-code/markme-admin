import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/session/placement_form.dart';
import 'package:markme_admin/features/placement/models/session/placement_session.dart';

import '../../models/session/session_attendance.dart';

abstract class PlacementSessionRepository {
  Future<Either<AppFailure, Unit>> addSession(PlacementSession session);
  Future<Either<AppFailure, Unit>> deleteSession(PlacementSession session);
  Future<Either<AppFailure, Unit>> updateSession(PlacementSession session);
  Future<Either<AppFailure, PlacementSession>> loadPlacementSession(
    String collegeId,
    String sessionId,
  );
  Future<Either<AppFailure, List<PlacementSession>>> loadLivePlacementSessions(
    String collegeId,
  );
  Future<Either<AppFailure, List<PlacementForm>>> loadSessionApplications(
    String collegeId,
    String sessionId,
  );
  Future<Either<AppFailure, Unit>> markAttendanceForSession(
    String collegeId,
    String sessionId,
    Map<String, bool> attendances,
  );
  Future<Either<AppFailure, Unit>> deleteAttendanceForSession(
    String collegeId,
    String sessionId,
  );
  Future<Either<AppFailure, SessionAttendanceModel?>> getAttendancesForSession(
      String collegeId,
      String sessionId,
      );
}
