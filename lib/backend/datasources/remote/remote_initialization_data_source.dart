import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_configuration.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/initialization_data.dart';
import '../../types/missions.dart';
import '../../types/user_roles.dart';
import '../../types/user_states.dart';

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

    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    if (response.body == '' || response.statusCode != 200) {
      throw ServerException();
    }
    final body = json.decode(response.body);
    print(body);

    AppConfiguration appConfiguration;
    UserRoleCollection userRoleCollection;
    UserStateCollection userStateCollection;
    MissionCollection missionCollection;

    try {
      appConfiguration = AppConfiguration.fromJson(body['appConfiguration']);
      userRoleCollection = UserRoleCollection.fromJson(body);
      userStateCollection = UserStateCollection.fromJson(body);
      missionCollection = MissionCollection.fromJson(body);
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    }

    return InitializationData(
        appConfiguration: appConfiguration,
        missionCollection: missionCollection,
        userStateCollection: userStateCollection,
        userRoleCollection: userRoleCollection);
  }
}
