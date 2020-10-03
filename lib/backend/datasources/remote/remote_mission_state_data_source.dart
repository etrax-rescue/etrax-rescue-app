import 'dart:convert';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';
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

  Future<void> triggerQuickAction(
    AppConnection appConnection,
    AuthenticationData authenticationData,
    UserState action,
    LocationData currentLocation,
  );
}

class RemoteMissionStateDataSourceImpl implements RemoteMissionStateDataSource {
  RemoteMissionStateDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<void> selectMission(AppConnection appConnection,
      AuthenticationData authenticationData, Mission mission) async {
    final request = client.post(
        appConnection.generateUri(subPath: EtraxServerEndpoints.missionSelect),
        headers: authenticationData.generateAuthHeader(),
        body: {'mission_id': mission.id.toString()});

    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }

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

    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }

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

    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }

    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> triggerQuickAction(
      AppConnection appConnection,
      AuthenticationData authenticationData,
      UserState action,
      LocationData currentLocation) async {
    final bodyMap = {
      'action_id': action.id.toString(),
      if (currentLocation != null) 'location': currentLocation.toMap(),
    };

    final headers = authenticationData.generateAuthHeader()
      ..addAll({HttpHeaders.contentTypeHeader: 'application/json'});

    final request = client.post(
        appConnection.generateUri(subPath: EtraxServerEndpoints.quickAction),
        headers: headers,
        body: json.encode(bodyMap));

    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }

    if (response.statusCode == 403) {
      throw AuthenticationException();
    }

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }
}
