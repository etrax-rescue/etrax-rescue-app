import 'dart:async';
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

  Future<bool> isMissionActive(
      AppConnection appConnection, AuthenticationData authenticationData);
}

class RemoteMissionStateDataSourceImpl implements RemoteMissionStateDataSource {
  RemoteMissionStateDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<void> selectMission(AppConnection appConnection,
      AuthenticationData authenticationData, Mission mission) async {
    http.Response response;
    try {
      response = await client.post(
          appConnection.generateUri(
              subPath: EtraxServerEndpoints.missionSelect),
          headers: authenticationData.generateAuthHeader(),
          body: {'mission_id': mission.id.toString()});
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

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> selectUserState(AppConnection appConnection,
      AuthenticationData authenticationData, UserState state) async {
    http.Response response;
    try {
      response = await client.post(
          appConnection.generateUri(subPath: EtraxServerEndpoints.stateSelect),
          headers: authenticationData.generateAuthHeader(),
          body: {'state_id': state.id.toString()});
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

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> selectUserRole(AppConnection appConnection,
      AuthenticationData authenticationData, UserRole role) async {
    http.Response response;
    try {
      response = await client.post(
          appConnection.generateUri(subPath: EtraxServerEndpoints.roleSelect),
          headers: authenticationData.generateAuthHeader(),
          body: {'role_id': role.id.toString()});
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

    http.Response response;
    try {
      response = await client.post(
          appConnection.generateUri(subPath: EtraxServerEndpoints.quickAction),
          headers: headers,
          body: json.encode(bodyMap));
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

    if (response.body != 'ok' || response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<bool> isMissionActive(AppConnection appConnection,
      AuthenticationData authenticationData) async {
    http.Response response;
    try {
      response = await client.get(
          appConnection.generateUri(subPath: EtraxServerEndpoints.quickAction),
          headers: authenticationData.generateAuthHeader());
    } on http.ClientException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    } on SocketException {
      throw ServerException();
    }

    if (response.statusCode == 401) {
      return false;
    }

    if (response.body == '1') {
      return true;
    } else {
      return false;
    }
  }
}
