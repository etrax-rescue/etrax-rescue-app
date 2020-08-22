import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../lib/core/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/app_connection_local_datasource.dart';
import '../../../../lib/backend/data/models/app_connection_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  AppConnectionLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AppConnectionLocalDataSourceImpl(mockSharedPreferences);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final AppConnectionModel tAppConnectionModel =
      AppConnectionModel(authority: tAuthority, basePath: tBasePath);

  group('getCachedAppConnection', () {
    test(
      'should return AppConnectionModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('app_connection/valid.json'));
        // act
        final result = await dataSource.getCachedAppConnection();
        // assert
        verify(mockSharedPreferences
            .getString(SharedPreferencesKeys.appConnection));
        expect(result, equals(tAppConnectionModel));
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
        dataSource.cacheAppConnection(tAppConnectionModel);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appConnection,
            json.encode(tAppConnectionModel.toJson())));
      },
    );
  });

  group('getAppConnectionUpdateStatus', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.cacheAppConnection(tAppConnectionModel);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.appConnection,
            json.encode(tAppConnectionModel.toJson())));
      },
    );
  });

  group('setAppConnectionUpdateStatus', () {
    test(
      'should call Shared preferences to store the update status',
      () async {
        // act
        dataSource.setAppConnectionUpdateStatus(true);
        // assert
        verify(mockSharedPreferences.setBool(
            SharedPreferencesKeys.appConnectionUpdate, true));
      },
    );
  });
}
