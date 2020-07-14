import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/types/shared_preferences_keys.dart';
import '../models/app_connection_model.dart';

abstract class AppConnectionLocalDataSource {
  Future<AppConnectionModel> getCachedAppConnection();
  Future<void> cacheAppConnection(AppConnectionModel model);
}

class AppConnectionLocalDataSourceImpl implements AppConnectionLocalDataSource {
  final SharedPreferences sharedPreferences;

  AppConnectionLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAppConnection(AppConnectionModel model) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.appConnection, json.encode(model.toJson()));
  }

  @override
  Future<AppConnectionModel> getCachedAppConnection() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.appConnection);
    if (data != null) {
      return AppConnectionModel.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }
}
