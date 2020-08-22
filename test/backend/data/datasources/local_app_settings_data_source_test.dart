import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../lib/core/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/local_app_settings_data_source.dart';
import '../../../../lib/backend/data/models/app_settings_model.dart';

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
  final tAppSettingsModel = AppSettingsModel(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);

  group('getAppSettings', () {
    test(
      'should return AppSettingsModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('app_settings/valid.json'));
        // act
        final result = await dataSource.getAppSettings();
        // assert
        verify(
            mockSharedPreferences.getString(SharedPreferencesKeys.appSettings));
        expect(result, equals(tAppSettingsModel));
      },
    );

    test(
      'should throw CacheException when no AppSettingsModel exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getAppSettings;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('storeAppSettings', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.storeAppSettings(tAppSettingsModel);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appSettings,
            json.encode(tAppSettingsModel.toJson())));
      },
    );
  });
}
