import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/etrax_server_endpoints.dart';

abstract class RemoteAppConnectionDataSource {
  Future<AppConnection> verifyRemoteEndpoint(String host, String basePath);
}

class RemoteAppConnectionDataSourceImpl
    implements RemoteAppConnectionDataSource {
  final http.Client client;
  RemoteAppConnectionDataSourceImpl(this.client);

  @override
  Future<AppConnection> verifyRemoteEndpoint(
      String host, String basePath) async {
    final path =
        Uri.parse(p.join(host, basePath, EtraxServerEndpoints.version));

    final request = client.get(path);

    http.Response response;
    try {
      response = await request.timeout(const Duration(seconds: 2));
    } on Exception {
      throw ServerException();
    }

    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return AppConnection(host: host, basePath: basePath);
    } else {
      throw ServerException();
    }
  }
}
