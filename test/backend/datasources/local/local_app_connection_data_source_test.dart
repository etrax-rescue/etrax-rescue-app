import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_app_connection_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalAppConnectionDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalAppConnectionDataSourceImpl(mockSharedPreferences);
  });

  group('getCachedAppConnection', () {
    test(
      'should return AppConnection from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('app_connection/valid.json'));
        // act
        final result = await dataSource.getCachedAppConnection();
        print('${result.host} ${result.basePath}');
        // assert
        verify(mockSharedPreferences
            .getString(SharedPreferencesKeys.appConnection));
        expect(result, equals(tAppConnection));
      },
    );

    test(
      'should throw CacheException when no AppConnection exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCachedAppConnection;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheAppConnection', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.cacheAppConnection(tAppConnection);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appConnection,
            json.encode(tAppConnection.toJson())));
      },
    );
  });

  group('getAppConnectionUpdateStatus', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.cacheAppConnection(tAppConnection);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appConnection,
            json.encode(tAppConnection.toJson())));
      },
    );
  });
}
