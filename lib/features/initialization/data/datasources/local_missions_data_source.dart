import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';

abstract class LocalMissionsDataSource {
  Future<void> insertMissions(MissionsModel missions);

  Future<void> updateMission(MissionModel mission);

  Future<MissionsModel> getMissions();

  Future<void> clearMissions();
}
