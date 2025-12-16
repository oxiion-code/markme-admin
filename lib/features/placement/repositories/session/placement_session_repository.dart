import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/placement/models/placement_form.dart';
import 'package:markme_admin/features/placement/models/session/placement_session.dart';

abstract class PlacementSessionRepository{
  Future<Either<AppFailure,Unit>> addSession(PlacementSession session);
  Future<Either<AppFailure,Unit>> deleteSession(PlacementSession session);
  Future<Either<AppFailure,Unit>> updateSession(PlacementSession session);
  Future<Either<AppFailure,PlacementSession>> loadPlacementSession(String collegeId,String sessionId);
}