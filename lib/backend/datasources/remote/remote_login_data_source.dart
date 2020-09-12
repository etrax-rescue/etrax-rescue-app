import 'dart:convert';

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
  final http.Client client;
  RemoteLoginDataSourceImpl(this.client);

  @override
  Future<AuthenticationData> login(AppConnection appConnection,
      String organizationID, String username, String password) async {
    final body = {
          'organization_id': organizationID,
          'username': username,
          'password': password
        };
    final url = appConnection.generateUri(subPath: EtraxServerEndpoints.login);
    final request = client.post(
        url,
	body: body);

    print(body);
    print(url);
    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }
    print('response: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body == null || response.body == '') {
        throw ServerException();
      }
      final jsonResponse = json.decode(response.body);
      jsonResponse['username'] = username;
      jsonResponse['organizationID'] = organizationID;
      jsonResponse['issuingDate'] =
          DateTime.now().millisecondsSinceEpoch.toString();
      final data = AuthenticationData.fromJson(jsonResponse);
      return data;
    } else if (response.statusCode == 401) {
      throw LoginException();
    } else {
      throw ServerException();
    }
  }
}
