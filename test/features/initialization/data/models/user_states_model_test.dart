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
  final tUserStatesModel =
      UserStateCollectionModel(states: <UserStateModel>[tUserStateModel]);

  group('UserState', () {
    test(
      'should be a subclass of UserState entity',
      () async {
        // assert
        expect(tUserStateModel, isA<UserState>());
      },
    );
  });

  group('UserStates', () {
    test(
      'should be a subclass of UserStates entity',
      () async {
        // assert
        expect(tUserStatesModel, isA<UserStateCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the states field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_states/states_missing.json'));
          // act & assert
          expect(() => UserStateCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON is missing the index level of the document',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_states/index_level_missing.json'));
          // act & assert
          expect(() => UserStateCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON is only contains the top level field states',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_states/top_level_only.json'));
          // act & assert
          expect(() => UserStateCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_states/no_name.json'));
          // act & assert
          expect(() => UserStateCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the UserModel has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_states/no_description.json'));
          final tModel = UserStateModel(id: tID, name: tName, description: '');
          final tModels =
              UserStateCollectionModel(states: <UserStateModel>[tModel]);
          // act
          final result = UserStateCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tModels);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_states/valid.json'));
          // act
          final result = UserStateCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tUserStatesModel);
        },
      );
    });
  });
}
