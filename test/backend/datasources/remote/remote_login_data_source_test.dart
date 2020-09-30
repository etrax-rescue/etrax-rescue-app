import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_login_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteLoginDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteLoginDataSourceImpl(mockedHttpClient);
  });

  group('login', () {
    test(
      'should perform a POST request on the login endpoint',
      () async {
        // arrange
        when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => http.Response(fixture('login/valid.json'), 200));
        // act
        await remoteDataSource.login(
            tAppConnection, tOrganizationID, tUsername, tPassword);
        // assert
        verify(mockedHttpClient.post(
            tAppConnection.generateUri(subPath: EtraxServerEndpoints.login),
            body: {
              'organization_id': tOrganizationID,
              'username': tUsername,
              'password': tPassword
            }));
      },
    );

    test(
      'should throw a ServerException when the response is empty',
      () async {
        // arrange
        when(mockedHttpClient.post(any, body: anyNamed('body')))
            .thenAnswer((_) async => http.Response('', 200));
        final call = remoteDataSource.login;
        // assert
        expect(
            () => call(tAppConnection, tOrganizationID, tUsername, tPassword),
            throwsA(TypeMatcher<ServerException>()));
      },
    );

    test(
      'should throw a FormatException when no token field is available in the json response',
      () async {
        // arrange
        when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => http.Response(fixture('login/invalid.json'), 200));
        final call = remoteDataSource.login;
        // assert
        expect(
            () => call(tAppConnection, tOrganizationID, tUsername, tPassword),
            throwsA(TypeMatcher<FormatException>()));
      },
    );

    test(
      'should throw a LoginException when the return code is 403 - permission denied',
      () async {
        // arrange
        when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => http.Response(fixture('login/valid.json'), 401));
        final call = remoteDataSource.login;
        // assert
        expect(
            () => call(tAppConnection, tOrganizationID, tUsername, tPassword),
            throwsA(TypeMatcher<LoginException>()));
      },
    );

    test(
      'should throw a ServerException when the return code is not 200',
      () async {
        // arrange
        when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => http.Response(fixture('login/valid.json'), 404));
        final call = remoteDataSource.login;
        // assert
        expect(
            () => call(tAppConnection, tOrganizationID, tUsername, tPassword),
            throwsA(TypeMatcher<ServerException>()));
      },
    );

    test(
      'should return a valid model when the required fields are provided in the JSON resonse',
      () async {
        // arrange
        when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
            (_) async => http.Response(fixture('login/valid.json'), 200));
        // act
        final result = await remoteDataSource.login(
            tAppConnection, tOrganizationID, tUsername, tPassword);
        // assert
        expect(result, tAuthenticationData);
      },
    );
  });
}
