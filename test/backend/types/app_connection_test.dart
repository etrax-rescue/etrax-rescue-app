import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../../lib/backend/types/app_connection.dart';

void main() {
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  group('generateUri', () {
    test(
      'should return a valid uri when no parameters are given',
      () async {
        // act
        final result = tAppConnection.generateUri();
        // assert
        expect(result, equals(Uri.https(tAuthority, tBasePath)));
      },
    );

    test(
      'should return a valid uri when a subPath is provided',
      () async {
        // arrange
        final tSubPath = 'test.php';
        // act
        final result = tAppConnection.generateUri(subPath: tSubPath);
        // assert
        expect(
            result, equals(Uri.https(tAuthority, tBasePath + '/' + tSubPath)));
      },
    );

    test(
      'should return a valid uri when a subPath and a param map are provided',
      () async {
        // arrange
        final tSubPath = 'test.php';
        final tParamMap = {
          'username': 'JohnDoe',
        };
        // act
        final result =
            tAppConnection.generateUri(subPath: tSubPath, paramMap: tParamMap);
        // assert
        expect(
            result,
            equals(
                Uri.https(tAuthority, p.join(tBasePath, tSubPath), tParamMap)));
      },
    );

    test(
      'should return a valid uri when no subPath but a param map is provided',
      () async {
        // arrange
        final tParamMap = {
          'username': 'JohnDoe',
        };
        // act
        final result = tAppConnection.generateUri(paramMap: tParamMap);
        // assert
        expect(result, equals(Uri.https(tAuthority, tBasePath, tParamMap)));
      },
    );
  });
}
