import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/types/app_connection.dart';
import '../../../../core/types/etrax_server_endpoints.dart';
import '../models/app_settings_model.dart';
import '../models/initialization_data_model.dart';
import '../models/missions_model.dart';
import '../models/user_roles_model.dart';
import '../models/user_states_model.dart';

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
    print(response.body);
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
      print('AppSettings done');
      userRoleCollectionModel = UserRoleCollectionModel.fromJson(body);
      print('Roles done');
      userStateCollectionModel = UserStateCollectionModel.fromJson(body);
      print('States done');
      missionCollectionModel = MissionCollectionModel.fromJson(body);
      print('Missions done');
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    }
    final initializationDataModel = InitializationDataModel(
        appSettingsModel: appSettingsModel,
        missionCollectionModel: missionCollectionModel,
        userStateCollectionModel: userStateCollectionModel,
        userRoleCollectionModel: userRoleCollectionModel);
    print(initializationDataModel);
    return initializationDataModel;
  }
}
