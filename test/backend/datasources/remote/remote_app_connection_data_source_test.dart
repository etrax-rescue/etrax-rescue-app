import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:path/path.dart' as p;

import 'package:etrax_rescue_app/backend/datasources/remote/remote_app_connection_data_source.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteAppConnectionDataSourceImpl endpointVerification;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    endpointVerification = RemoteAppConnectionDataSourceImpl(mockedHttpClient);
  });

  test(
    'should perform GET request on the /appdata/version_info.json endpoint',
    () async {
      // arrange
      when(mockedHttpClient.get(any)).thenAnswer((_) async =>
          http.Response(fixture('version/version_info.json'), 200));
      // act
      await endpointVerification.verifyRemoteEndpoint(tHost, tBasePath);
      // assert
      verify(mockedHttpClient.get(
          Uri.parse(p.join(tHost, tBasePath, EtraxServerEndpoints.version))));
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
      final result =
          await endpointVerification.verifyRemoteEndpoint(tHost, tBasePath);
      // assert
      expect(result, equals(tAppConnection));
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
      expect(() => call(tHost, tBasePath),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw a ServerException when a HTTP client exception occurs ',
    () async {
      // arrange
      when(mockedHttpClient.get(any)).thenThrow(http.ClientException(''));
      // act
      final call = endpointVerification.verifyRemoteEndpoint;
      // assert
      expect(() => call(tHost, tBasePath),
          throwsA(TypeMatcher<ServerException>()));
    },
  );
}
