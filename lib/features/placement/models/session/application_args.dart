import 'package:markme_admin/features/placement/models/session/placement_session.dart';

class ApplicationArgs {
  final String collegeId;
  final PlacementSession placementSession;
  const ApplicationArgs({required this.placementSession, required this.collegeId});
}