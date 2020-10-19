import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/search_area.dart';

abstract class RemoteSearchAreaDataSource {
  Future<SearchAreaCollection> fetchSearchAreas(
      AppConnection appConnection, AuthenticationData authenticationData);
}

class RemoteSearchAreaDataSourceImpl implements RemoteSearchAreaDataSource {
  RemoteSearchAreaDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<SearchAreaCollection> fetchSearchAreas(AppConnection appConnection,
      AuthenticationData authenticationData) async {
    http.Response response;
    try {
      response = await client.get(
        appConnection.generateUri(subPath: EtraxServerEndpoints.searchArea),
        headers: authenticationData.generateAuthHeader(),
      );
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

    if (response.body == '' || response.statusCode != 200) {
      throw ServerException();
    }

    final body = json.decode(response.body);
    SearchAreaCollection searchAreaCollection;
    try {
      searchAreaCollection = SearchAreaCollection.fromJson(body);
    } on NoSuchMethodError {
      throw ServerException();
    } on FormatException {
      throw ServerException();
    } on TypeError {
      throw ServerException();
    }
    return searchAreaCollection;
  }
}
