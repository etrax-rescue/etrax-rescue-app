import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_organizations_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../reference_types.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteOrganizationsDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteOrganizationsDataSourceImpl(mockedHttpClient);
  });

  group('getOrganizations', () {
    test(
      'should perform a GET request on the organizations endpoint',
      () async {
        // arrange
        when(mockedHttpClient.get(any)).thenAnswer((_) async =>
            http.Response(fixture('organization_collection/valid.json'), 200));
        final uri = tAppConnection.generateUri(
            subPath: EtraxServerEndpoints.organizations);
        // act
        await remoteDataSource.getOrganizations(tAppConnection);
        // assert
        verify(mockedHttpClient.get(uri));
      },
    );

    test(
      'should throw a ServerException when the response is empty',
      () async {
        // arrange
        when(mockedHttpClient.get(any))
            .thenAnswer((_) async => http.Response('', 200));
        final call = remoteDataSource.getOrganizations;
        // assert
        expect(() => call(tAppConnection),
            throwsA(TypeMatcher<ServerException>()));
      },
    );

    test(
      'should throw a ServerException when the JSON response is not an array',
      () async {
        // arrange
        when(mockedHttpClient.get(any)).thenAnswer((_) async => http.Response(
            fixture('organization_collection/no_array.json'), 200));
        // act
        final call = remoteDataSource.getOrganizations;
        // assert
        expect(() => call(tAppConnection),
            throwsA(TypeMatcher<ServerException>()));
      },
    );

    test(
      'should return a OrganizationCollection',
      () async {
        // arrange
        when(mockedHttpClient.get(any)).thenAnswer((_) async =>
            http.Response(fixture('organization_collection/valid.json'), 200));
        // act
        final result = await remoteDataSource.getOrganizations(tAppConnection);
        // assert
        expect(result, equals(tOrganizationCollection));
      },
    );
  });
}
