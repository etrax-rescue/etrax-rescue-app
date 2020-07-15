import 'dart:convert';
import 'dart:io';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:http/http.dart' as http;

import '../models/initialization_data_model.dart';

abstract class RemoteInitializationDataSource {
  Future<InitializationDataModel> fetchInitialization(
      AppConnection appConnection, String username, String token);
}

class RemoteInitializationDataSourceImpl
    implements RemoteInitializationDataSource {
  final http.Client client;
  RemoteInitializationDataSourceImpl(this.client);

  @override
  Future<InitializationDataModel> fetchInitialization(
      AppConnection appConnection, String username, String token) async {
    final authString = base64.encode(utf8.encode('$username:$token'));
    final request = client.get(
        appConnection.generateUri(subPath: EtraxServerEndpoints.initialization),
        headers: {HttpHeaders.authorizationHeader: 'Basic $authString'});
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.body == '') {
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
        appSettingsModel: appSettingsModel,
        missionCollectionModel: missionCollectionModel,
        userStateCollectionModel: userStateCollectionModel,
        userRoleCollectionModel: userRoleCollectionModel);
  }
}
