import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import 'dart:convert';

import 'package:etrax_rescue_app/backend/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/types/organizations.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_organizations_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  LocalOrganizationsDataSourceImpl dataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalOrganizationsDataSourceImpl(mockSharedPreferences);
  });

  group('getCachedOrganizations', () {
    test(
      'should return OrganizationCollection from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('organization_collection/valid.json'));
        // act
        final result = await dataSource.getCachedOrganizations();
        // assert
        verify(mockSharedPreferences
            .getString(SharedPreferencesKeys.organizations));
        expect(result, equals(tOrganizationCollection));
      },
    );

    test(
      'should throw CacheException when no OrganizationsCollection exists in the shared preferences',
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
        dataSource.cacheOrganizations(tOrganizationCollection);
        // assert
        verify(mockSharedPreferences.setString(
            SharedPreferencesKeys.organizations,
            json.encode(tOrganizationCollection.toJson())));
      },
    );
  });
}
