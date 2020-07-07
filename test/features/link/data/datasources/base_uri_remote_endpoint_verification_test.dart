import 'dart:math';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/link/data/datasources/base_uri_remote_endpoint_verification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  BaseUriRemoteEndpointVerificationImpl endpointVerification;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    endpointVerification =
        BaseUriRemoteEndpointVerificationImpl(mockedHttpClient);
  });

  final String tBaseUri = 'https://www.etrax.at';

  test(
    'should perform GET request on the /version endpoint',
    () async {
      // arrange
      when(mockedHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(fixture('version_info.json'), 200));
      // act
      endpointVerification.verifyRemoteEndpoint(tBaseUri);
      // assert
      verify(mockedHttpClient.get(tBaseUri + '/version'));
    },
  );

  test(
    'should return true when the /version endpoint is accessible and the version of the server software is greater than or equal to the local version',
    () async {
      // TODO: How should we handle different versions?
      // arrange
      when(mockedHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(fixture('version_info.json'), 200));
      // act
      final result = await endpointVerification.verifyRemoteEndpoint(tBaseUri);
      // assert
      expect(result, equals(true));
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
      expect(() => call(tBaseUri), throwsA(TypeMatcher<ServerException>()));
    },
  );
}
