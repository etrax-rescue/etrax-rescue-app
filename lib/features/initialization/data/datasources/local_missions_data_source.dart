import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';

abstract class LocalMissionsDataSource {
  Future<void> insertMissions(MissionCollectionModel missions);

  Future<void> updateMission(MissionModel mission);

  Future<MissionCollectionModel> getMissions();

  Future<void> clearMissions();
}
