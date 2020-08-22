import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../../core/error/exceptions.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/app_connection.dart';

abstract class RemoteAppConnectionEndpointVerification {
  Future<AppConnection> verifyRemoteEndpoint(String authority, String basePath);
}

class RemoteAppConnectionEndpointVerificationImpl
    implements RemoteAppConnectionEndpointVerification {
  final http.Client client;
  RemoteAppConnectionEndpointVerificationImpl(this.client);

  @override
  Future<AppConnection> verifyRemoteEndpoint(
      String authority, String basePath) async {
    final request = client.get(
        Uri.https(authority, p.join(basePath, EtraxServerEndpoints.version)));
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return AppConnection(authority: authority, basePath: basePath);
    } else {
      throw ServerException();
    }
  }
}
