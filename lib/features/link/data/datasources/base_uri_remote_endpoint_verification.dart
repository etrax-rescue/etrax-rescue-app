import 'package:etrax_rescue_app/core/error/exceptions.dart';

import '../models/base_uri_model.dart';
import 'package:http/http.dart' as http;

abstract class BaseUriRemoteEndpointVerification {
  Future<bool> verifyRemoteEndpoint(String baseUri);
}

class BaseUriRemoteEndpointVerificationImpl
    implements BaseUriRemoteEndpointVerification {
  final http.Client client;
  BaseUriRemoteEndpointVerificationImpl(this.client);

  @override
  Future<bool> verifyRemoteEndpoint(String baseUri) async {
    final response = await client.get(baseUri + '/version');
    if (response.statusCode == 200) {
      // TODO: how should we handle different versions?
      return true;
    } else {
      throw ServerException();
    }
  }
}
