import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../../core/types/app_connection.dart';
import '../../../core/types/authentication_data.dart';
import '../../../core/types/etrax_server_endpoints.dart';
import '../models/app_settings_model.dart';
import '../models/initialization_data_model.dart';
import '../models/missions_model.dart';
import '../models/user_roles_model.dart';
import '../models/user_states_model.dart';

abstract class RemoteInitializationDataSource {
  Future<InitializationDataModel> fetchInitialization(
      AppConnection appConnection, AuthenticationData authenticationData);
}

class RemoteInitializationDataSourceImpl
    implements RemoteInitializationDataSource {
  final http.Client client;
  RemoteInitializationDataSourceImpl(this.client);

  @override
  Future<InitializationDataModel> fetchInitialization(
      AppConnection appConnection,
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

    AppSettingsModel appSettingsModel;
    UserRoleCollectionModel userRoleCollectionModel;
    UserStateCollectionModel userStateCollectionModel;
    MissionCollectionModel missionCollectionModel;

    try {
      appSettingsModel = AppSettingsModel.fromJson(body['appSettings']);
      userRoleCollectionModel = UserRoleCollectionModel.fromJson(body);
      userStateCollectionModel = UserStateCollectionModel.fromJson(body);
      missionCollectionModel = MissionCollectionModel.fromJson(body);
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    }

    return InitializationDataModel(
        appSettings: appSettingsModel,
        missionCollection: missionCollectionModel,
        userStateCollection: userStateCollectionModel,
        userRoleCollection: userRoleCollectionModel);
  }
}