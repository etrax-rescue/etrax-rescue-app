import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../../../core/error/exceptions.dart';
import '../models/app_connection_model.dart';

abstract class AppConnectionRemoteEndpointVerification {
  Future<AppConnectionModel> verifyRemoteEndpoint(
      String authority, String basePath);
}

class AppConnectionRemoteEndpointVerificationImpl
    implements AppConnectionRemoteEndpointVerification {
  final http.Client client;
  AppConnectionRemoteEndpointVerificationImpl(this.client);

  @override
  Future<AppConnectionModel> verifyRemoteEndpoint(
      String authority, String basePath) async {
    final request = client.get(
        Uri.https(authority, p.join(basePath, EtraxServerEndpoints.version)));
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return AppConnectionModel(authority: authority, basePath: basePath);
    } else {
      throw ServerException();
    }
  }
}
