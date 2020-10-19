import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/initialization_data.dart';

abstract class RemoteInitializationDataSource {
  Future<InitializationData> fetchInitialization(
      AppConnection appConnection, AuthenticationData authenticationData);
}

class RemoteInitializationDataSourceImpl
    implements RemoteInitializationDataSource {
  RemoteInitializationDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<InitializationData> fetchInitialization(AppConnection appConnection,
      AuthenticationData authenticationData) async {
    http.Response response;
    try {
      response = await client.get(
          appConnection.generateUri(
              subPath: EtraxServerEndpoints.initialization),
          headers: authenticationData.generateAuthHeader());
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
    try {
      final initializationData = InitializationData.fromJson(body);
      return initializationData;
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    }
  }
}
