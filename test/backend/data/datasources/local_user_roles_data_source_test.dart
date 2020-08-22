import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../lib/core/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/local_user_roles_data_source.dart';
import '../../../../lib/backend/data/models/user_roles_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalUserRolesDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalUserRolesDataSourceImpl(mockSharedPreferences);
  });

  final tID = 42;
  final tName = 'operator';
  final tDescription = 'the one who does stuff';
  final tUserRoleModel =
      UserRoleModel(id: tID, name: tName, description: tDescription);
  final tUserRoleCollectionModel =
      UserRoleCollectionModel(roles: <UserRoleModel>[tUserRoleModel]);

  group('getUserRoles', () {
    test(
      'should return UserRoleCollectionModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('user_role_collection/valid.json'));
        // act
        final result = await dataSource.getUserRoles();
        // assert
        verify(
            mockSharedPreferences.getString(SharedPreferencesKeys.userRoles));
        expect(result, equals(tUserRoleCollectionModel));
      },
    );

    test(
      'should throw CacheException when no UserRoleCollectionModel exists in the shared preferences',
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
        dataSource.storeUserRoles(tUserRoleCollectionModel);
        // assert
        verify(mockSharedPreferences.setString(SharedPreferencesKeys.userRoles,
            json.encode(tUserRoleCollectionModel.toJson())));
      },
    );
  });
}
