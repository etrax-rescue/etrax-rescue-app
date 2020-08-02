import 'dart:convert';

import 'package:etrax_rescue_app/features/authentication/data/models/organizations_model.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/organizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tID = 'DEV';
  final tName = 'Rettungshunde';
  final tOrganizationModel = OrganizationModel(id: tID, name: tName);
  final tOrganizationCollectionModel = OrganizationCollectionModel(
      organizations: <OrganizationModel>[tOrganizationModel]);

  group('OrganizationModel', () {
    test(
      'should be a subclass of Organization entity',
      () async {
        // assert
        expect(tOrganizationModel, isA<Organization>());
      },
    );
    group('fromJson', () {
      test(
        'should throw a FormatException when the OrganizationModel has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization/no_name.json'));
          // act & assert
          expect(() => OrganizationModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the OrganizationModel has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization/no_id.json'));
          // act & assert
          expect(() => OrganizationModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization/valid.json'));
          // act
          final result = OrganizationModel.fromJson(jsonMap);
          // assert
          expect(result, tOrganizationModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tOrganizationModel.toJson();
          // assert
          final expectedJsonMap = {'id': tID, 'name': tName};
          expect(result, expectedJsonMap);
        },
      );
    });
  });

  group('OrganizationCollectionModel', () {
    test(
      'should be a subclass of OrganizationCollection entity',
      () async {
        // assert
        expect(tOrganizationCollectionModel, isA<OrganizationCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should throw a FormatException when the JSON is missing the organizations field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
              fixture('organization_collection/organizations_missing.json'));
          // act & assert
          expect(() => OrganizationCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the JSON does not contain an array',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization_collection/no_array.json'));
          // act & assert
          expect(() => OrganizationCollectionModel.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization_collection/valid.json'));
          // act
          final result = OrganizationCollectionModel.fromJson(jsonMap);
          // assert
          expect(result, tOrganizationCollectionModel);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the OrganizationCollectionModel contains a null element',
        () async {
          // arrange
          final tModel = OrganizationCollectionModel(
              organizations: <OrganizationModel>[tOrganizationModel, null]);
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
          final result = tOrganizationCollectionModel.toJson();
          // assert
          final expectedJsonMap = {
            'organizations': [
              {'id': tID, 'name': tName},
            ],
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
