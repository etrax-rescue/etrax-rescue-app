import 'dart:convert';

import 'package:etrax_rescue_app/core/types/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/data/datasources/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/backend/data/models/user_states_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

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
  final tUserStateModel = UserStateModel(
      id: tID,
      name: tName,
      description: tDescription,
      locationAccuracy: tLocationAccuracy);
  final tUserStateCollectionModel =
      UserStateCollectionModel(states: <UserStateModel>[tUserStateModel]);

  group('getUserStates', () {
    test(
      'should return UserStateCollectionModel from the Shared Preferences when one instance exists in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('user_state_collection/valid.json'));
        // act
        final result = await dataSource.getUserStates();
        // assert
        verify(
            mockSharedPreferences.getString(SharedPreferencesKeys.userStates));
        expect(result, equals(tUserStateCollectionModel));
      },
    );

    test(
      'should throw CacheException when no UserStateCollectionModel exists in the shared preferences',
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
        dataSource.storeUserStates(tUserStateCollectionModel);
        // assert
        verify(mockSharedPreferences.setString(SharedPreferencesKeys.userStates,
            json.encode(tUserStateCollectionModel.toJson())));
      },
    );
  });
}
