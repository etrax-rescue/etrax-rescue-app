import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMissionID = '0123456789ABCDEF';
  final tMissionName = 'TestMission';
  final tMissionStart = DateTime.utc(2020, 1, 1);
  final tLatitude = 48.2206635;
  final tLongitude = 16.309849;
  final tMissionModel = MissionModel(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionsModel = MissionsModel(missions: <MissionModel>[tMissionModel]);
  test(
    'should be a subclass of Missions entity',
    () async {
      // assert
      expect(tMissionsModel, isA<Missions>());
    },
  );
}
