import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_user_roles_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalUserRolesDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalUserRolesDataSourceImpl(mockSharedPreferences);
  });

  group('getUserRoles', () {
    test(
      'should return UserRoleCollection from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('user_role_collection/valid.json'));
        // act
        final result = await dataSource.getUserRoles();
        // assert
        verify(
            mockSharedPreferences.getString(SharedPreferencesKeys.userRoles));
        expect(result, equals(tUserRoleCollection));
      },
    );

    test(
      'should throw CacheException when no UserRoleCollection exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getUserRoles;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('storeUserRoles', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.storeUserRoles(tUserRoleCollection);
        // assert
        verify(mockSharedPreferences.setString(SharedPreferencesKeys.userRoles,
            json.encode(tUserRoleCollection.toJson())));
      },
    );
  });
}
