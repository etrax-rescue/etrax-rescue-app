import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared_preferences_keys.dart';
import '../models/base_uri_model.dart';

abstract class BaseUriLocalDataSource {
  Future<BaseUriModel> getCachedBaseUri();
  Future<void> cacheBaseUri(String baseUri);
}

class BaseUriLocalDataSourceImpl implements BaseUriLocalDataSource {
  final SharedPreferences sharedPreferences;

  BaseUriLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheBaseUri(String baseUri) async {
    sharedPreferences.setString(CACHE_BASE_URI, baseUri);
  }

  @override
  Future<BaseUriModel> getCachedBaseUri() async {
    final data = sharedPreferences.getString(CACHE_BASE_URI);
    if (data != null) {
      return BaseUriModel(baseUri: data);
    } else {
      throw CacheException();
    }
  }
}
