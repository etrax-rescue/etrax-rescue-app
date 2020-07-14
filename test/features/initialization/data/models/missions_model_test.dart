import 'dart:convert';

import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

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
  final tMissionsModel =
      MissionCollectionModel(missions: <MissionModel>[tMissionModel]);
  group('MissionModel', () {
    test(
      'should be a subclass of Mission entity',
      () async {
        // assert
        expect(tMissionModel, isA<Mission>());
      },
    );
  });
  group('MissionsModel', () {
    test(
      'should be a subclass of Missions entity',
      () async {
        // assert
        expect(tMissionsModel, isA<MissionCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the states field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('missions/states_missing.json'));
          // act & assert
          expect(() => MissionCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON is only contains the top level field states',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('missions/top_level_only.json'));
          // act & assert
          expect(() => MissionCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the MissionModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('missions/no_name.json'));
          // act & assert
          expect(() => MissionCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('missions/valid.json'));
          // act
          final result = MissionCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tMissionsModel);
        },
      );
    });
  });
}
