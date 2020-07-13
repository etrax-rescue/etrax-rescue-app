import 'package:etrax_rescue_app/common/app_connection/data/models/app_connection_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../../../core/error/exceptions.dart';

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
    final request =
        client.get(Uri.https(authority, p.join(basePath, 'version_info.json')));
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return AppConnectionModel(authority: authority, basePath: basePath);
    } else {
      throw ServerException();
    }
  }
}
