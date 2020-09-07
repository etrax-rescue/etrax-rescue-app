import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/mission_details.dart';

abstract class RemoteMissionDetailsDataSource {
  Future<MissionDetailCollection> fetchMissionDetails(
      AppConnection appConnection, AuthenticationData authenticationData);
}

class RemoteMissionDetailsDataSourceImpl
    implements RemoteMissionDetailsDataSource {
  RemoteMissionDetailsDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<MissionDetailCollection> fetchMissionDetails(
      AppConnection appConnection,
      AuthenticationData authenticationData) async {
    final request = client.get(
      appConnection.generateUri(subPath: EtraxServerEndpoints.missionDetails),
      headers: authenticationData.generateAuthHeader(),
    );

    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }

    if (response.statusCode == 401) {
      throw AuthenticationException();
    }

    if (response.body == '' || response.statusCode != 200) {
      throw ServerException();
    }

    final body = json.decode(response.body);
    MissionDetailCollection detailCollection;
    try {
      detailCollection = MissionDetailCollection.fromJson(body);
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    } on TypeError {
      throw ServerException();
    }
    return detailCollection;
  }
}
