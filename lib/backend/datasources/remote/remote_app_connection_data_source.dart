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
  RemoteAppConnectionDataSourceImpl(this.client);

  final http.Client client;

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
      return AppConnection(host: host, basePath: basePath);
    } else {
      throw ServerException();
    }
  }
}
