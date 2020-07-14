import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/features/app_connection/data/models/app_connection_model.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/app_connection/data/datasources/app_connection_remote_endpoint_verification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:path/path.dart' as p;

import '../../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  AppConnectionRemoteEndpointVerificationImpl endpointVerification;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    endpointVerification =
        AppConnectionRemoteEndpointVerificationImpl(mockedHttpClient);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnectionModel =
      AppConnectionModel(authority: tAuthority, basePath: tBasePath);

  test(
    'should perform GET request on the /appdata/version_info.json endpoint',
    () async {
      // arrange
      when(mockedHttpClient.get(any)).thenAnswer((_) async =>
          http.Response(fixture('version/version_info.json'), 200));
      // act
      await endpointVerification.verifyRemoteEndpoint(tAuthority, tBasePath);
      // assert
      verify(mockedHttpClient.get(Uri.https(
          tAuthority, p.join(tBasePath, EtraxServerEndpoints.version))));
    },
  );

  test(
    'should return true when the /version endpoint is accessible and the version of the server software is greater than or equal to the local version',
    () async {
      // TODO: How should we handle different versions?
      // arrange
      when(mockedHttpClient.get(any)).thenAnswer((_) async =>
          http.Response(fixture('version/version_info.json'), 200));
      // act
      final result = await endpointVerification.verifyRemoteEndpoint(
          tAuthority, tBasePath);
      // assert
      expect(result, equals(tAppConnectionModel));
    },
  );

  test(
    'should throw ServerException on non 200 exit code',
    () async {
      // arrange
      when(mockedHttpClient.get(any))
          .thenAnswer((_) async => http.Response("Whoopsie.", 404));
      // act
      final call = endpointVerification.verifyRemoteEndpoint;
      // assert
      expect(() => call(tAuthority, tBasePath),
          throwsA(TypeMatcher<ServerException>()));
    },
  );
}
