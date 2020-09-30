import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/user_states.dart';

import '../../fixtures/fixture_reader.dart';
import '../../reference_types.dart';

void main() {
  group('UserState', () {
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
              id: tUserStateID,
              name: tUserStateName,
              description: '',
              locationAccuracy: tUserStateLocationAccuracy);
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
            'id': tUserStateID,
            'name': tUserStateName,
            'description': tUserStateDescription,
            'locationAccuracy': tUserStateLocationAccuracy,
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });

  group('UserStateCollection', () {
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
                'id': tUserStateID,
                'name': tUserStateName,
                'description': tUserStateDescription,
                'locationAccuracy': tUserStateLocationAccuracy,
              },
            ],
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
