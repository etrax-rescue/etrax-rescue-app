import 'dart:convert';

import 'package:etrax_rescue_app/backend/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/backend/domain/entities/user_roles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tID = 42;
  final tName = 'operator';
  final tDescription = 'the one who does stuff';
  final tUserRoleModel =
      UserRoleModel(id: tID, name: tName, description: tDescription);
  final tUserRoleCollectionModel =
      UserRoleCollectionModel(roles: <UserRoleModel>[tUserRoleModel]);

  group('UserRoleModel', () {
    test(
      'should be a subclass of UserRole entity',
      () async {
        // assert
        expect(tUserRoleModel, isA<UserRole>());
      },
    );
    group('fromJson', () {
      test(
        'should throw a FormatException when the UserRoleModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/no_name.json'));
          // act & assert
          expect(() => UserRoleModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserRoleModel has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/no_id.json'));
          // act & assert
          expect(() => UserRoleModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the UserRoleModel has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/no_description.json'));
          final tModel = UserRoleModel(id: tID, name: tName, description: '');
          // act
          final result = UserRoleModel.fromJson(jsonMap);
          // assert
          expect(result, tModel);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/valid.json'));
          // act
          final result = UserRoleModel.fromJson(jsonMap);
          // assert
          expect(result, tUserRoleModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tUserRoleModel.toJson();
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

  group('UserRoleCollectionModel', () {
    test(
      'should be a subclass of UserRoles entity',
      () async {
        // assert
        expect(tUserRoleCollectionModel, isA<UserRoleCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the roles field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role_collection/roles_missing.json'));
          // act & assert
          expect(() => UserRoleCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON does not contain an array',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role_collection/no_array.json'));
          // act & assert
          expect(() => UserRoleCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role_collection/valid.json'));
          // act
          final result = UserRoleCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tUserRoleCollectionModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the UserRoleCollectionModel contains a null element',
        () async {
          // arrange
          final tModel = UserRoleCollectionModel(
              roles: <UserRoleModel>[tUserRoleModel, null]);
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
          final result = tUserRoleCollectionModel.toJson();
          // assert
          final expectedJsonMap = {
            'roles': [
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
