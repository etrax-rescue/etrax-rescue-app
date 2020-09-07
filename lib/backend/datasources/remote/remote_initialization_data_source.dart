import 'dart:convert';

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
  final http.Client client;
  RemoteInitializationDataSourceImpl(this.client);

  @override
  Future<InitializationData> fetchInitialization(AppConnection appConnection,
      AuthenticationData authenticationData) async {
    final request = client.get(
        appConnection.generateUri(subPath: EtraxServerEndpoints.initialization),
        headers: authenticationData.generateAuthHeader());

    final response = await request.timeout(const Duration(seconds: 2));

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
