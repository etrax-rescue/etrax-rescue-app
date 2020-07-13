import 'dart:convert';

import 'package:etrax_rescue_app/core/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/app_connection/data/datasources/app_connection_local_datasource.dart';
import 'package:etrax_rescue_app/features/app_connection/data/models/app_connection_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

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
            .thenReturn(fixture('app_connection.json'));
        // act
        final result = await dataSource.getCachedAppConnection();
        // assert
        verify(mockSharedPreferences.getString(CACHE_APP_CONNECTION));
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
            CACHE_APP_CONNECTION, json.encode(tAppConnectionModel.toJson())));
      },
    );
  });
}
