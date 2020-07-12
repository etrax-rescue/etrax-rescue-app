import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMissionID = '0123456789ABCDEF';
  final tMissionName = 'TestMission';
  final tMissionStart = DateTime.utc(2020, 1, 1);
  final tMissionModel = MissionModel(
      missionID: tMissionID,
      missionName: tMissionName,
      missionStart: tMissionStart);
  final tMissionsModel = MissionsModel(missions: <MissionModel>[tMissionModel]);
  test(
    'should be a subclass of Missions entity',
    () async {
      // assert
      expect(tMissionsModel, isA<Missions>());
    },
  );
}
