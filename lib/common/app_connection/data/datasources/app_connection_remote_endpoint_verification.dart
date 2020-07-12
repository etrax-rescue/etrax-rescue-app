import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

abstract class AppConnectionRemoteEndpointVerification {
  Future<bool> verifyRemoteEndpoint(String baseUri);
}

class AppConnectionRemoteEndpointVerificationImpl
    implements AppConnectionRemoteEndpointVerification {
  final http.Client client;
  AppConnectionRemoteEndpointVerificationImpl(this.client);

  @override
  Future<bool> verifyRemoteEndpoint(String baseUri) async {
    final request = client.get(baseUri + '/appdata/version_info.json');
    final response = await request.timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return true;
    } else {
      throw ServerException();
    }
  }
}
