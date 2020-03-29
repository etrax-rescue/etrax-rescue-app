import 'dart:convert';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/person/data/datasources/person_info_remote_data_source.dart';
import 'package:etrax_rescue_app/features/person/data/models/person_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  PersonInfoRemoteDataSourceImpl dataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    dataSource = PersonInfoRemoteDataSourceImpl(client: mockedHttpClient);
  });

  final Uri tUri = Uri.parse("https://etrax.at/person");
  final String tToken = "0123456789ABCDEF";
  final tEid = "0123456789ABCDEF";

  final tPersonInfoModel =
      PersonInfoModel.fromJson(json.decode(fixture('person_info.json')));

  test(
    'should perform a POST request',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('person_info.json'), 200));
      // act
      dataSource.getPersonInfo(tUri, tToken, tEid);
      // assert
      verify(mockedHttpClient
          .post(tUri.toString(), body: {'token': tToken, 'eid': tEid}));
    },
  );

  test(
    'should return a valid PersonInfoModel when the response code is 200 and the token is acceped',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(fixture('person_info.json'), 200));
      // act
      final result = await dataSource.getPersonInfo(tUri, tToken, tEid);
      // assert
      expect(result, tPersonInfoModel);
    },
  );

  test(
    'should throw ServerError on non 200 exit code',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response("You shall not pass.", 502));
      // act
      final call = dataSource.getPersonInfo;
      // assert
      expect(() => call(tUri, tToken, tEid),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    '''should throw ServerException if the lastSeen field in the provided json is incorrectly'''
    '''formatted''',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async =>
              http.Response(fixture('person_info_wrong_datetime.json'), 200));
      // act
      final call = dataSource.getPersonInfo;
      // assert
      expect(() => call(tUri, tToken, tEid),
          throwsA(TypeMatcher<ServerException>()));
    },
  );

  test(
    'should throw ServerException if the provided JSON lacks a required field',
    () async {
      // arrange
      when(mockedHttpClient.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async =>
              http.Response(fixture('person_info_incomplete.json'), 200));
      // act
      final call = dataSource.getPersonInfo;
      // assert
      expect(() => call(tUri, tToken, tEid),
          throwsA(TypeMatcher<ServerException>()));
    },
  );
}
