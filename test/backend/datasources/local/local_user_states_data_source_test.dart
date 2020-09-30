import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/datasources/local/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/backend/types/user_states.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalUserStatesDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalUserStatesDataSourceImpl(mockSharedPreferences);
  });

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
