import 'dart:convert';
import 'dart:io';

import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/missions.dart';
import '../../types/user_roles.dart';
import '../../types/user_states.dart';

abstract class RemoteMissionStateDataSource {
  Future<void> selectUserState(AppConnection appConnection,
      AuthenticationData authenticationData, UserState state);

  Future<void> selectMission(AppConnection appConnection,
      AuthenticationData authenticationData, Mission mission);

  Future<void> selectUserRole(AppConnection appConnection,
      AuthenticationData authenticationData, UserRole role);
}

class RemoteMissionStateDataSourceImpl implements RemoteMissionStateDataSource {
  final http.Client client;

  RemoteMissionStateDataSourceImpl(this.client);

  @override
  Future<void> selectMission(AppConnection appConnection,
      AuthenticationData authenticationData, Mission mission) async {
    final request = client.post(
        appConnection.generateUri(subPath: EtraxServerEndpoints.missionSelect),
        headers: authenticationData.generateAuthHeader(),
        body: {'mission_id': mission.id.toString()});

    final response = await request.timeout(const Duration(seconds: 2));

    if (response.statusCode == 401) {
      throw AuthenticationException();
    }

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> selectUserState(AppConnection appConnection,
      AuthenticationData authenticationData, UserState state) async {
    final request = client.post(
        appConnection.generateUri(subPath: EtraxServerEndpoints.stateSelect),
        headers: authenticationData.generateAuthHeader(),
        body: {'state_id': state.id.toString()});

    final response = await request.timeout(const Duration(seconds: 2));

    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> selectUserRole(AppConnection appConnection,
      AuthenticationData authenticationData, UserRole role) async {
    final request = client.post(
        appConnection.generateUri(subPath: EtraxServerEndpoints.roleSelect),
        headers: authenticationData.generateAuthHeader(),
        body: {'role_id': role.id.toString()});

    final response = await request.timeout(const Duration(seconds: 2));
    print(response.statusCode);
    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }
}
