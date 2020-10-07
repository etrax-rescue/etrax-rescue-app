import 'dart:convert';

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
    final request = client.get(
      appConnection.generateUri(subPath: EtraxServerEndpoints.searchArea),
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
