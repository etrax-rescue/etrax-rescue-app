import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_missions_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalMissionsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalMissionsDataSourceImpl(mockSharedPreferences);
  });

  group('getMissions', () {
    test(
      'should return MissionCollection from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('mission_collection/valid.json'));
        // act
        final result = await dataSource.getMissions();
        // assert
        verify(mockSharedPreferences.getString(SharedPreferencesKeys.missions));
        expect(result, equals(tMissionCollection));
      },
    );

    test(
      'should throw CacheException when no UserStateCollection exists in the shared preferences',
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
        dataSource.insertMissions(tMissionCollection);
        // assert
        verify(mockSharedPreferences.setString(SharedPreferencesKeys.missions,
            json.encode(tMissionCollection.toJson())));
      },
    );
  });
}
