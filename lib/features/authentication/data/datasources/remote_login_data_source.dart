import 'dart:convert';

import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/types/app_connection.dart';
import '../models/authentication_data_model.dart';

abstract class RemoteLoginDataSource {
  Future<AuthenticationDataModel> login(
      AppConnection appConnection, String username, String password);
}

class RemoteLoginDataSourceImpl implements RemoteLoginDataSource {
  final http.Client client;
  RemoteLoginDataSourceImpl(this.client);

  @override
  Future<AuthenticationDataModel> login(
      AppConnection appConnection, String username, String password) async {
    final request = client.post(
        appConnection.generateUri(subPath: EtraxServerEndpoints.login),
        body: {'username': username, 'password': password});

    // TODO: This delay is required until https://github.com/flutter/flutter/issues/41573 is resolved
    await Future<void>.delayed(Duration(milliseconds: 100));
    final response = await request.timeout(const Duration(seconds: 2));

    if (response.statusCode == 200) {
      if (response.body == null || response.body == '') {
        throw ServerException();
      }
      final jsonResponse = json.decode(response.body);
      jsonResponse['username'] = username;
      final data = AuthenticationDataModel.fromJson(jsonResponse);
      return data;
    } else if (response.statusCode == 401) {
      throw LoginException();
    } else {
      throw ServerException();
    }
  }
}
