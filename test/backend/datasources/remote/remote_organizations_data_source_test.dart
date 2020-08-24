import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/core/error/exceptions.dart';
import '../../../../lib/backend/types/etrax_server_endpoints.dart';
import '../../../../lib/backend/datasources/remote/remote_organizations_data_source.dart';
import '../../../../lib/backend/types/authentication_data.dart';
import '../../../../lib/backend/types/organizations.dart';

import '../../../fixtures/fixture_reader.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  RemoteOrganizationsDataSourceImpl remoteDataSource;
  MockedHttpClient mockedHttpClient;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    remoteDataSource = RemoteOrganizationsDataSourceImpl(mockedHttpClient);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  final tOrganizationID = 'DEV';
  final tUsername = 'JohnDoe';
  final tPassword = '0123456789ABCDEF';
  final tToken = '0123456789ABCDEF';
  final AuthenticationData tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);

  final tName = 'Rettungshunde';
  final tOrganization = Organization(id: tOrganizationID, name: tName);
  final tOrganizationCollection =
      OrganizationCollection(organizations: <Organization>[tOrganization]);

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
