import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../lib/core/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/local_missions_data_source.dart';
import '../../../../lib/backend/data/models/missions_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalMissionsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalMissionsDataSourceImpl(mockSharedPreferences);
  });

  final tMissionID = 42;
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

  group('getMissions', () {
    test(
      'should return MissionCollectionModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('mission_collection/valid.json'));
        // act
        final result = await dataSource.getMissions();
        // assert
        verify(mockSharedPreferences.getString(SharedPreferencesKeys.missions));
        expect(result, equals(tMissionCollectionModel));
      },
    );

    test(
      'should throw CacheException when no UserStateCollectionModel exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getMissions;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('insertMissions', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.insertMissions(tMissionCollectionModel);
        // assert
        verify(mockSharedPreferences.setString(SharedPreferencesKeys.missions,
            json.encode(tMissionCollectionModel.toJson())));
      },
    );
  });
}
