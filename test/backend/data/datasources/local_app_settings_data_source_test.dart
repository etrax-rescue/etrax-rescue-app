import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../lib/backend/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/local_app_settings_data_source.dart';
import '../../../../lib/backend/types/app_configuration.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalAppSettingsDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalAppSettingsDataSourceImpl(mockSharedPreferences);
  });

  final tLocationUpdateInterval = 0;
  final tLocationUpdateMinDistance = 50;
  final tInfoUpdateInterval = 300;
  final tAppConfiguration = AppConfiguration(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);

  group('getAppConfiguration', () {
    test(
      'should return AppConfiguration from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('app_settings/valid.json'));
        // act
        final result = await dataSource.getAppConfiguration();
        // assert
        verify(mockSharedPreferences
            .getString(SharedPreferencesKeys.appConfiguration));
        expect(result, equals(tAppConfiguration));
      },
    );

    test(
      'should throw CacheException when no AppConfiguration exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getAppConfiguration;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('storeAppConfiguration', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.storeAppConfiguration(tAppConfiguration);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appConfiguration,
            json.encode(tAppConfiguration.toJson())));
      },
    );
  });
}
