import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  group('createUri', () {
    test(
      'should return a valid uri when no parameters are given',
      () async {
        // act
        final result = tAppConnection.createUri();
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
        final result = tAppConnection.createUri(subPath: tSubPath);
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
            tAppConnection.createUri(subPath: tSubPath, paramMap: tParamMap);
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
        final result = tAppConnection.createUri(paramMap: tParamMap);
        // assert
        expect(result, equals(Uri.https(tAuthority, tBasePath, tParamMap)));
      },
    );
  });
}