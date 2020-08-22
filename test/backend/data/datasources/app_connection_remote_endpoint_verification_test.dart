import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:path/path.dart' as p;

import '../../../../lib/backend/types/etrax_server_endpoints.dart';
import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/data/datasources/remote_app_connection_endpoint_verification.dart';

import '../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteAppConnectionEndpointVerificationImpl endpointVerification;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    endpointVerification =
        RemoteAppConnectionEndpointVerificationImpl(mockedHttpClient);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnectionModel =
      AppConnection(authority: tAuthority, basePath: tBasePath);

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
