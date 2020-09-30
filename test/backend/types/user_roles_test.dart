import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/user_roles.dart';

import '../../fixtures/fixture_reader.dart';
import '../../reference_types.dart';

void main() {
  group('UserRole', () {
    group('fromJson', () {
      test(
        'should throw a FormatException when the UserRole has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/no_name.json'));
          // act & assert
          expect(() => UserRole.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserRole has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/no_id.json'));
          // act & assert
          expect(() => UserRole.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the UserRole has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/no_description.json'));
          final t =
              UserRole(id: tUserRoleID, name: tUserRoleName, description: '');
          // act
          final result = UserRole.fromJson(jsonMap);
          // assert
          expect(result, t);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role/valid.json'));
          // act
          final result = UserRole.fromJson(jsonMap);
          // assert
          expect(result, tUserRole);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tUserRole.toJson();
          // assert
          final expectedJsonMap = {
            'id': tUserRoleID,
            'name': tUserRoleName,
            'description': tUserRoleDescription,
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });

  group('UserRoleCollection', () {
    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the roles field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_role_collection/roles_missing.json'));
          // act & assert
          expect(() => UserRoleCollection.fromJson(jsonMap),
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
          expect(() => UserRoleCollection.fromJson(jsonMap),
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
          final result = UserRoleCollection.fromJson(jsonMap);
          // assert
          expect(result, tUserRoleCollection);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the UserRoleCollection contains a null element',
        () async {
          // arrange
          final t = UserRoleCollection(roles: <UserRole>[tUserRole, null]);
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
          final result = tUserRoleCollection.toJson();
          // assert
          final expectedJsonMap = {
            'roles': [
              {
                'id': tUserRoleID,
                'name': tUserRoleName,
                'description': tUserRoleDescription,
              },
            ],
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
