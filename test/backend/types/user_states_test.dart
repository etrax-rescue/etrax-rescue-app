import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../lib/backend/types/user_states.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
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

  group('UserState', () {
    test(
      'should be a subclass of UserState entity',
      () async {
        // assert
        expect(tUserState, isA<UserState>());
      },
    );
    group('fromJson', () {
      test(
        'should throw a FormatException when the UserState has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_name.json'));
          // act & assert
          expect(() => UserState.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserState has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_id.json'));
          // act & assert
          expect(() => UserState.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserState has no locationAccuracy field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_location_accuracy.json'));
          // act & assert
          expect(() => UserState.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the UserState has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_description.json'));
          final t = UserState(
              id: tID,
              name: tName,
              description: '',
              locationAccuracy: tLocationAccuracy);
          // act
          final result = UserState.fromJson(jsonMap);
          // assert
          expect(result, t);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/valid.json'));
          // act
          final result = UserState.fromJson(jsonMap);
          // assert
          expect(result, tUserState);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tUserState.toJson();
          // assert
          final expectedJsonMap = {
            'id': tID,
            'name': tName,
            'description': tDescription,
            'locationAccuracy': tLocationAccuracy,
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });

  group('UserStateCollection', () {
    test(
      'should be a subclass of UserStateCollection entity',
      () async {
        // assert
        expect(tUserStateCollection, isA<UserStateCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the states field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state_collection/states_missing.json'));
          // act & assert
          expect(() => UserStateCollection.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON does not contain an array',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state_collection/no_array.json'));
          // act & assert
          expect(() => UserStateCollection.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state_collection/valid.json'));
          // act
          final result = UserStateCollection.fromJson(jsonMap);
          // assert
          expect(result, tUserStateCollection);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the UserStateCollection contains a null element',
        () async {
          // arrange
          final t = UserStateCollection(states: <UserState>[tUserState, null]);
          // act
          final call = t.toJson;
          // assert
          expect(() => call(), throwsA(TypeMatcher<FormatException>()));
        },
      );
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tUserStateCollection.toJson();
          // assert
          final expectedJsonMap = {
            'states': [
              {
                'id': tID,
                'name': tName,
                'description': tDescription,
                'locationAccuracy': tLocationAccuracy,
              },
            ],
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
