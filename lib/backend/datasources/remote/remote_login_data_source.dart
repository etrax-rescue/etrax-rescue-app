import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';

abstract class RemoteLoginDataSource {
  Future<AuthenticationData> login(AppConnection appConnection,
      String organizationID, String username, String password);
}

class RemoteLoginDataSourceImpl implements RemoteLoginDataSource {
  RemoteLoginDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<AuthenticationData> login(AppConnection appConnection,
      String organizationID, String username, String password) async {
    http.Response response;
    try {
      response = await client.post(
          appConnection.generateUri(subPath: EtraxServerEndpoints.login),
          body: {
            'organization_id': organizationID,
            'username': username,
            'password': password
          });
    } on http.ClientException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    } on SocketException {
      throw ServerException();
    }

    if (response.statusCode == 200) {
      if (response.body == null || response.body == '') {
        throw ServerException();
      }
      final jsonResponse = json.decode(response.body);
      jsonResponse['username'] = username;
      jsonResponse['organization_id'] = organizationID;
      final data = AuthenticationData.fromJson(jsonResponse);
      return data;
    } else if (response.statusCode == 401) {
      throw LoginException();
    } else if (response.statusCode == 429) {
      throw TooManyTrysException();
    } else {
      throw ServerException();
    }
  }
}
