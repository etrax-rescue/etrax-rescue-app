import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/app_connection.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalAppConnectionDataSource {
  Future<AppConnection> getCachedAppConnection();
  Future<void> cacheAppConnection(AppConnection model);
  Future<void> deleteAppConnection();
}

class LocalAppConnectionDataSourceImpl implements LocalAppConnectionDataSource {
  LocalAppConnectionDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheAppConnection(AppConnection model) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.appConnection, json.encode(model.toJson()));
  }

  @override
  Future<AppConnection> getCachedAppConnection() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.appConnection);
    if (data != null) {
      return AppConnection.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteAppConnection() async {
    await sharedPreferences.remove(SharedPreferencesKeys.appConnection);
  }
}
