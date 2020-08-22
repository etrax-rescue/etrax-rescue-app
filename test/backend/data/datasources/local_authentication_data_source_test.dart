import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import 'dart:convert';

import '../../../../lib/core/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/local_authentication_data_source.dart';
import '../../../../lib/backend/data/models/authentication_data_model.dart';
import '../../../../lib/backend/data/models/organizations_model.dart';

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
  final tAuthenticationDataModel = AuthenticationDataModel(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  final tID = 'DEV';
  final tName = 'Rettungshunde';
  final tOrganizationModel = OrganizationModel(id: tID, name: tName);
  final tOrganizationCollectionModel = OrganizationCollectionModel(
      organizations: <OrganizationModel>[tOrganizationModel]);

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

  group('getCachedOrganizations', () {
    test(
      'should return OrganizationCollectionModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('organization_collection/valid.json'));
        // act
        final result = await dataSource.getCachedOrganizations();
        // assert
        verify(mockSharedPreferences
            .getString(SharedPreferencesKeys.organizations));
        expect(result, equals(tOrganizationCollectionModel));
      },
    );

    test(
      'should throw CacheException when no OrganizationsCollectionModel exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getCachedOrganizations;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheOrganizations', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.cacheOrganizations(tOrganizationCollectionModel);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.organizations,
            json.encode(tOrganizationCollectionModel.toJson())));
      },
    );
  });
}
