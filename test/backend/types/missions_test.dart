import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../lib/backend/types/missions.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tMissionID = 42;
  final tMissionName = 'Wien';
  final tMissionStart = DateTime.utc(2020, 2, 2, 20, 20, 2, 20);
  final tLatitude = 48.2084114;
  final tLongitude = 16.3712767;
  final tMission = Mission(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionCollection = MissionCollection(missions: <Mission>[tMission]);
  group('Mission', () {
    group('fromJson', () {
      test(
        'should throw a FormatException when the Mission has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_id.json'));
          // act & assert
          expect(() => Mission.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the Mission has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_name.json'));
          // act & assert
          expect(() => Mission.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the Mission has no start field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_start.json'));
          // act & assert
          expect(() => Mission.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the Mission has an improperly formatted start field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/wrong_start.json'));
          // act & assert
          expect(() => Mission.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a model without coordinates when the Mission has no latitude field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_latitude.json'));
          final t = Mission(
              id: tMissionID,
              name: tMissionName,
              start: tMissionStart,
              latitude: null,
              longitude: null);
          // act
          final result = Mission.fromJson(jsonMap);
          // assert
          expect(result, t);
        },
      );

      test(
        'should return a model without coordinates when the Mission has no longitude field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_longitude.json'));
          final t = Mission(
              id: tMissionID,
              name: tMissionName,
              start: tMissionStart,
              latitude: null,
              longitude: null);
          // act
          final result = Mission.fromJson(jsonMap);
          // assert
          expect(result, t);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/valid.json'));
          // act
          final result = Mission.fromJson(jsonMap);
          // assert
          expect(result, tMission);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tMission.toJson();
          // assert
          final expectedJsonMap = {
            'id': tMissionID,
            'name': tMissionName,
            'start': tMissionStart.toIso8601String(),
            'latitude': tLatitude,
            'longitude': tLongitude,
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
  group('MissionCollection', () {
    test(
      'should be a subclass of MissionCollection entity',
      () async {
        // assert
        expect(tMissionCollection, isA<MissionCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the missions field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission_collection/missions_missing.json'));
          // act & assert
          expect(() => MissionCollection.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON does not contain an array',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission_collection/no_array.json'));
          // act & assert
          expect(() => MissionCollection.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission_collection/valid.json'));
          // act
          final result = MissionCollection.fromJson(jsonMap);
          // assert
          expect(result, tMissionCollection);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the MissionCollection contains a null element',
        () async {
          // arrange
          final t = MissionCollection(missions: <Mission>[tMission, null]);
          // act
          final call = t.toJson;
          // assert
          expect(() => call(), throwsA(TypeMatcher<FormatException>()));
        },
      );
      test(
        'formatted date string should equal initial date string',
        () async {
          // arrange
          final tDate = DateTime.utc(2020, 2, 2, 20, 20, 2, 20);
          // act
          final result = tDate.toIso8601String();
          // assert
          expect(result, equals('2020-02-02T20:20:02.020Z'));
        },
      );
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tMissionCollection.toJson();
          // assert
          final expectedJsonMap = {
            'missions': [
              {
                'id': tMissionID,
                'name': tMissionName,
                'start': tMissionStart.toIso8601String(),
                'latitude': tLatitude,
                'longitude': tLongitude,
              },
            ],
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
