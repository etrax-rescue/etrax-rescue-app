import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/backend/types/organizations.dart';

import '../../fixtures/fixture_reader.dart';
import '../../reference_types.dart';

void main() {
  group('Organization', () {
    group('fromJson', () {
      test(
        'should throw a FormatException when the Organization has no name field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization/no_name.json'));
          // act & assert
          expect(() => Organization.fromJson(jsonMap),
              throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should throw a FormatException when the Organization has no id field',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('organization/no_id.json'));
          // act & assert
          expect(() => Organization.fromJson(jsonMap),
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
          final result = Organization.fromJson(jsonMap);
          // assert
          expect(result, tOrganization);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = tOrganization.toJson();
          // assert
          final expectedJsonMap = {
            'id': tOrganizationID,
            'name': tOrganizationName
          };
          expect(result, expectedJsonMap);
        },
      );
    });
  });

  group('OrganizationCollection', () {
    test(
      'should be a subclass of OrganizationCollection entity',
      () async {
        // assert
        expect(tOrganizationCollection, isA<OrganizationCollection>());
      },
    );

    group('fromJson', () {
      test(
        'should return a valid model when the JSON is properly formatted',
        () async {
          // arrange
          final List<dynamic> jsonMap =
              json.decode(fixture('organization_collection/valid.json'));
          // act
          final result = OrganizationCollection.fromJson(jsonMap);
          // assert
          expect(result, tOrganizationCollection);
        },
      );
    });

    group('toJson', () {
      test(
        'should throw FormatException when the OrganizationCollection contains a null element',
        () async {
          // arrange
          final t = OrganizationCollection(
              organizations: <Organization>[tOrganization, null]);
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
          final result = tOrganizationCollection.toJson();
          // assert
          final expectedJsonMap = [
            {'id': tOrganizationID, 'name': tOrganizationName},
          ];
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
