import 'package:etrax_rescue_app/core/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/local_authentication_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  LocalAuthenticationDataSourceImpl dataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalAuthenticationDataSourceImpl(mockSharedPreferences);
  });

  final String tUsername = 'JohnDoe';
  final String tToken = '0123456789ABCDEF';
  final AuthenticationDataModel tAuthenticationDataModel =
      AuthenticationDataModel(username: tUsername, token: tToken);

  group('getCachedAuthenticationData', () {
    test(
      'should return AuthenticationData from the SharedPreferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('authentication_data/valid.json'));
        // act
        final result = await dataSource.getCachedAuthenticationData();
        // assert
        verify(mockSharedPreferences
            .getString(SharedPreferencesKeys.authenticationData));
        expect(result, equals(tAuthenticationDataModel));
      },
    );
    test(
      'should throw CacheException when the AuthenticationData instance does not exist in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCachedAuthenticationData;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheAuthenticationData', () {
    test(
      'should call SharedPreferences to store the data',
      () async {
        // act
        dataSource.cacheAuthenticationData(tAuthenticationDataModel);
        // assert
        final expectedJsonString =
            json.encode(tAuthenticationDataModel.toJson());
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.authenticationData, expectedJsonString));
      },
    );
  });

  group('deleteAuthenticationData', () {
    test(
      'should call SharedPreferences to delete the data',
      () async {
        // act
        dataSource.deleteAuthenticationData();
        // assert
        verify(mockSharedPreferences
            .remove(SharedPreferencesKeys.authenticationData));
      },
    );
  });
}
