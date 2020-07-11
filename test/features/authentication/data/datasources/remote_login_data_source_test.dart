import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/remote_login_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteLoginDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteLoginDataSourceImpl(mockedHttpClient);
  });

  final String tBaseUri = 'https://www.etrax.at';
  final String tUsername = 'JohnDoe';
  final String tPassword = '0123456789ABCDEF';
  final String tToken = '0123456789ABCDEF';
  final AuthenticationDataModel tAuthenticationDataModel =
      AuthenticationDataModel(username: tUsername, token: tToken);

  test(
    'should perform a POST request on the /login.php endpoint',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('login_success.json'), 200));
      // act
      await remoteDataSource.login(tBaseUri, tUsername, tPassword);
      // assert
      verify(mockedHttpClient.post(tBaseUri + '/login.php',
          body: {'username': tUsername, 'password': tPassword}));
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
      expect(() => call(tBaseUri, tUsername, tPassword),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw a FormatException when no token field is available in the json response',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('login_wrong_reply.json'), 200));
      final call = remoteDataSource.login;
      // assert
      expect(() => call(tBaseUri, tUsername, tPassword),
          throwsA(TypeMatcher<FormatException>()));
    },
  );

  test(
    'should throw a PermissionException when the return code is 403 - permission denied',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('login_success.json'), 403));
      final call = remoteDataSource.login;
      // assert
      expect(() => call(tBaseUri, tUsername, tPassword),
          throwsA(TypeMatcher<PermissionException>()));
    },
  );

  test(
    'should throw a ServerException when the return code is not 200',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('login_success.json'), 404));
      final call = remoteDataSource.login;
      // assert
      expect(() => call(tBaseUri, tUsername, tPassword),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should return a valid model when the required fields are provided in the JSON resonse',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('login_success.json'), 200));
      // act
      final result =
          await remoteDataSource.login(tBaseUri, tUsername, tPassword);
      // assert
      expect(result, tAuthenticationDataModel);
    },
  );
}
