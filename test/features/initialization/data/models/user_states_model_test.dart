import 'dart:convert';

import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tID = 42;
  final tName = 'approaching';
  final tDescription = 'is on their way';
  final tUserStateModel =
      UserStateModel(id: tID, name: tName, description: tDescription);
  final tUserStateCollectionModel =
      UserStateCollectionModel(states: <UserStateModel>[tUserStateModel]);

  group('UserStateModel', () {
    test(
      'should be a subclass of UserState entity',
      () async {
        // assert
        expect(tUserStateModel, isA<UserState>());
      },
    );
    group('fromJson', () {
      test(
        'should throw a FormatException when the UserStateModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_name.json'));
          // act & assert
          expect(() => UserStateModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserStateModel has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_id.json'));
          // act & assert
          expect(() => UserStateModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the UserStateModel has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/no_description.json'));
          final tModel = UserStateModel(id: tID, name: tName, description: '');
          // act
          final result = UserStateModel.fromJson(jsonMap);
          // assert
          expect(result, tModel);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_state/valid.json'));
          // act
          final result = UserStateModel.fromJson(jsonMap);
          // assert
          expect(result, tUserStateModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tUserStateModel.toJson();
          // assert
          final expectedJsonMap = {
            'id': tID,
            'name': tName,
            'description': tDescription,
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });

  group('UserStateCollectionModel', () {
    test(
      'should be a subclass of UserStateCollection entity',
      () async {
        // assert
        expect(tUserStateCollectionModel, isA<UserStateCollection>());
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
          expect(() => UserStateCollectionModel.fromJson(jsonMap),
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
          expect(() => UserStateCollectionModel.fromJson(jsonMap),
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
          final result = UserStateCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tUserStateCollectionModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the UserStateCollectionModel contains a null element',
        () async {
          // arrange
          final tModel = UserStateCollectionModel(
              states: <UserStateModel>[tUserStateModel, null]);
          // act
          final call = tModel.toJson;
          // assert
          expect(() => call(), throwsA(TypeMatcher<FormatException>()));
        },
      );
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tUserStateCollectionModel.toJson();
          // assert
          final expectedJsonMap = {
            'states': [
              {
                'id': tID,
                'name': tName,
                'description': tDescription,
              },
            ],
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
