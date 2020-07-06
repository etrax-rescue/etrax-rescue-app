import '../models/base_uri_model.dart';

abstract class BaseUriRemoteEndpointVerification {
  Future<bool> verifyRemoteEndpoint(String baseUri);
}
