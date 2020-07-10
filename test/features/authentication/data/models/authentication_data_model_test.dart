import 'dart:convert';

import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final String tUsername = 'JohnDoe';
  final String tToken = '0123456789ABCDEF';
  final AuthenticationDataModel tAuthenticationDataModel =
      AuthenticationDataModel(username: tUsername, token: tToken);
  test(
    'should be a subclass of LoginData entity',
    () async {
      // assert
      expect(tAuthenticationDataModel, isA<AuthenticationData>());
    },
  );

  group('fromJson', () {
    test(
      'should throw a FormatException when the json map is missing one of the required fields',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('authentication_data_invalid.json'));
        // assert
        expect(() => AuthenticationDataModel.fromJson(jsonMap),
            throwsA(TypeMatcher<FormatException>()));
      },
    );
    test(
      'should return a valid model when only the required fields are provided in the JSON resonse',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('authentication_data.json'));
        // act
        final result = AuthenticationDataModel.fromJson(jsonMap);
        // assert
        expect(result, tAuthenticationDataModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tAuthenticationDataModel.toJson();
        // assert
        final expectedMap = {
          'username': tUsername,
          'token': tToken,
        };
        expect(result, equals(expectedMap));
      },
    );
  });
}
