import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import 'dart:convert';

import '../../../../lib/backend/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/datasources/local/local_authentication_data_source.dart';
import '../../../../lib/backend/types/authentication_data.dart';
import '../../../../lib/backend/types/organizations.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  LocalAuthenticationDataSourceImpl dataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalAuthenticationDataSourceImpl(mockSharedPreferences);
  });

  final tOrganizationID = 'DEV';
  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';
  final tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  final tID = 'DEV';
  final tName = 'Rettungshunde';
  final tOrganization = Organization(id: tID, name: tName);
  final tOrganizationCollection =
      OrganizationCollection(organizations: <Organization>[tOrganization]);

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
        expect(result, equals(tAuthenticationData));
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
        dataSource.cacheAuthenticationData(tAuthenticationData);
        // assert
        final expectedJsonString = json.encode(tAuthenticationData.toJson());
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
