import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:etrax_rescue_app/common/app_connection/domain/entities/app_connection.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
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
        Uri.https(appConnection.authority,
            p.join(appConnection.basePath, 'login.php')),
        body: {'username': username, 'password': password});
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      if (response.body == null || response.body == '') {
        throw ServerException();
      }
      final jsonResponse = json.decode(response.body);
      jsonResponse['username'] = username;
      final data = AuthenticationDataModel.fromJson(jsonResponse);
      return data;
    } else if (response.statusCode == 403) {
      throw PermissionException();
    } else {
      throw ServerException();
    }
  }
}
