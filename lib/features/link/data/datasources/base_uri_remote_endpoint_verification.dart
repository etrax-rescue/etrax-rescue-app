import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

abstract class BaseUriRemoteEndpointVerification {
  Future<bool> verifyRemoteEndpoint(String baseUri);
}

class BaseUriRemoteEndpointVerificationImpl
    implements BaseUriRemoteEndpointVerification {
  final http.Client client;
  BaseUriRemoteEndpointVerificationImpl(this.client);

  @override
  Future<bool> verifyRemoteEndpoint(String baseUri) async {
    final response = await client.get(baseUri + '/version_info.json');
    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return true;
    } else {
      throw ServerException();
    }
  }
}
