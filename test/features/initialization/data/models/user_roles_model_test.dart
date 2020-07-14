import 'dart:convert';

import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_roles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tID = 42;
  final tName = 'operator';
  final tDescription = 'the one who does stuff';
  final tUserRoleModel =
      UserRoleModel(id: tID, name: tName, description: tDescription);
  final tUserRolesModel =
      UserRoleCollectionModel(roles: <UserRoleModel>[tUserRoleModel]);

  group('UserRole', () {
    test(
      'should be a subclass of UserRole entity',
      () async {
        // assert
        expect(tUserRoleModel, isA<UserRole>());
      },
    );
  });

  group('UserRoles', () {
    test(
      'should be a subclass of UserRoles entity',
      () async {
        // assert
        expect(tUserRolesModel, isA<UserRoleCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the roles field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_roles/roles_missing.json'));
          // act & assert
          expect(() => UserRoleCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON is missing the index level of the document',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_roles/index_level_missing.json'));
          // act & assert
          expect(() => UserRoleCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON is only contains the top level field roles',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_roles/top_level_only.json'));
          // act & assert
          expect(() => UserRoleCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the UserModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_roles/no_name.json'));
          // act & assert
          expect(() => UserRoleCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the UserModel has no description field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_roles/no_description.json'));
          final tModel = UserRoleModel(id: tID, name: tName, description: '');
          final tModels =
              UserRoleCollectionModel(roles: <UserRoleModel>[tModel]);
          // act
          final result = UserRoleCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tModels);
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('user_roles/valid.json'));
          // act
          final result = UserRoleCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tUserRolesModel);
        },
      );
    });
  });
}
