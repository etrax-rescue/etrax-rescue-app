import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared_preferences_keys.dart';
import '../models/app_connection_model.dart';

abstract class AppConnectionLocalDataSource {
  Future<AppConnectionModel> getCachedAppConnection();
  Future<void> cacheAppConnection(String baseUri);
}

class AppConnectionLocalDataSourceImpl implements AppConnectionLocalDataSource {
  final SharedPreferences sharedPreferences;

  AppConnectionLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAppConnection(String baseUri) async {
    sharedPreferences.setString(CACHE_APP_CONNECTION, baseUri);
  }

  @override
  Future<AppConnectionModel> getCachedAppConnection() async {
    final data = sharedPreferences.getString(CACHE_APP_CONNECTION);
    if (data != null) {
      return AppConnectionModel(baseUri: data);
    } else {
      throw CacheException();
    }
  }
}
