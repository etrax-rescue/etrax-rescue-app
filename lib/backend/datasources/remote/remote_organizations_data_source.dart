import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/organizations.dart';

abstract class RemoteOrganizationsDataSource {
  Future<OrganizationCollection> getOrganizations(AppConnection appConnection);
}

class RemoteOrganizationsDataSourceImpl
    implements RemoteOrganizationsDataSource {
  RemoteOrganizationsDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<OrganizationCollection> getOrganizations(
      AppConnection appConnection) async {
    http.Response response;
    try {
      response = await client.get(appConnection.generateUri(
          subPath: EtraxServerEndpoints.organizations));
    } on http.ClientException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    } on SocketException {
      throw ServerException();
    }

    if (response.statusCode == 401) {
      throw AuthenticationException();
    }

    if (response.body == '' || response.statusCode != 200) {
      throw ServerException();
    }
    final body = json.decode(response.body);
    OrganizationCollection organizationCollection;
    try {
      organizationCollection = OrganizationCollection.fromJson(body);
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    } on TypeError {
      throw ServerException();
    }
    return organizationCollection;
  }
}
