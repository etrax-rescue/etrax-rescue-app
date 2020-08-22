import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../lib/backend/types/shared_preferences_keys.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/local_user_states_data_source.dart';
import '../../../../lib/backend/types/user_states.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalUserStatesDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalUserStatesDataSourceImpl(mockSharedPreferences);
  });

  final tID = 42;
  final tName = 'approaching';
  final tDescription = 'is on their way';
  final tLocationAccuracy = 2;
  final tUserState = UserState(
      id: tID,
      name: tName,
      description: tDescription,
      locationAccuracy: tLocationAccuracy);
  final tUserStateCollection =
      UserStateCollection(states: <UserState>[tUserState]);

  group('getUserStates', () {
    test(
      'should return UserStateCollection from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('user_state_collection/valid.json'));
        // act
        final result = await dataSource.getUserStates();
        // assert
        verify(
            mockSharedPreferences.getString(SharedPreferencesKeys.userStates));
        expect(result, equals(tUserStateCollection));
      },
    );

    test(
      'should throw CacheException when no UserStateCollection exists in the shared preferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getUserStates;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('storeUserStates', () {
    test(
      'should call Shared Preferences to store the data',
      () async {
        // act
        dataSource.storeUserStates(tUserStateCollection);
        // assert
        verify(mockSharedPreferences.setString(SharedPreferencesKeys.userStates,
            json.encode(tUserStateCollection.toJson())));
      },
    );
  });
}
