import 'dart:convert';

import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMissionID = '1234abcd';
  final tMissionName = 'Wien';
  final tMissionStart = DateTime.utc(2020, 2, 2, 20, 20, 2, 20);
  final tLatitude = 48.2084114;
  final tLongitude = 16.3712767;
  final tMissionModel = MissionModel(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionCollectionModel =
      MissionCollectionModel(missions: <MissionModel>[tMissionModel]);
  group('MissionModel', () {
    test(
      'should be a subclass of Mission entity',
      () async {
        // assert
        expect(tMissionModel, isA<Mission>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the MissionModel has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_id.json'));
          // act & assert
          expect(() => MissionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the MissionModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_name.json'));
          // act & assert
          expect(() => MissionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the MissionModel has no start field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_start.json'));
          // act & assert
          expect(() => MissionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the MissionModel has an improperly formatted start field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/wrong_start.json'));
          // act & assert
          expect(() => MissionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a model without coordinates when the MissionModel has no latitude field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_latitude.json'));
          final tModel = MissionModel(
              id: tMissionID,
              name: tMissionName,
              start: tMissionStart,
              latitude: null,
              longitude: null);
          // act
          final result = MissionModel.fromJson(jsonMap);
          // assert
          expect(result, tModel);
        },
      );

      test(
        'should return a model without coordinates when the MissionModel has no longitude field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/no_longitude.json'));
          final tModel = MissionModel(
              id: tMissionID,
              name: tMissionName,
              start: tMissionStart,
              latitude: null,
              longitude: null);
          // act
          final result = MissionModel.fromJson(jsonMap);
          // assert
          expect(result, tModel);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('mission/valid.json'));
          // act
          final result = MissionModel.fromJson(jsonMap);
          // assert
          expect(result, tMissionModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tMissionModel.toJson();
          // assert
          final expectedJsonMap = {
            'id': tMissionID,
            'name': tMissionName,
            'start': tMissionStart,
            'latitude': tLatitude,
            'longitude': tLongitude,
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
  group('MissionCollectionModel', () {
    test(
      'should be a subclass of MissionCollection entity',
      () async {
        // assert
        expect(tMissionCollectionModel, isA<MissionCollection>());
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
          expect(() => MissionCollectionModel.fromJson(jsonMap),
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
          expect(() => MissionCollectionModel.fromJson(jsonMap),
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
          final result = MissionCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tMissionCollectionModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the MissionCollectionModel contains a null element',
        () async {
          // arrange
          final tModel = MissionCollectionModel(
              missions: <MissionModel>[tMissionModel, null]);
          // act
          final call = tModel.toJson;
          // assert
          expect(() => call(), throwsA(TypeMatcher<FormatException>()));
        },
      );
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tMissionCollectionModel.toJson();
          // assert
          final expectedJsonMap = {
            'missions': [
              {
                'id': tMissionID,
                'name': tMissionName,
                'start': tMissionStart,
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
