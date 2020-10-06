import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_app_configuration_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalAppConfigurationDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalAppConfigurationDataSourceImpl(mockSharedPreferences);
  });

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

  group('setAppConfiguration', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        await dataSource.setAppConfiguration(tAppConfiguration);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appConfiguration,
            json.encode(tAppConfiguration.toJson())));
      },
    );
  });

  group('deleteAppConfiguration', () {
    test(
      'should delete the entry from Shared Preferences',
      () async {
        // act
        await dataSource.deleteAppConfiguration();
        // assert
        verify(mockSharedPreferences
            .remove(SharedPreferencesKeys.appConfiguration));
      },
    );
  });
}
