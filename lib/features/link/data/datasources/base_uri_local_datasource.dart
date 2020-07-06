import '../models/base_uri_model.dart';

abstract class BaseUriLocalDataSource {
  Future<BaseUriModel> getCachedBaseUri();
  Future<void> cacheBaseUri(String baseUri);
}
