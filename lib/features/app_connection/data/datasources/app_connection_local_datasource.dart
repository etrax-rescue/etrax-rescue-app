import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/types/shared_preferences_keys.dart';
import '../models/app_connection_model.dart';

abstract class AppConnectionLocalDataSource {
  Future<AppConnectionModel> getCachedAppConnection();
  Future<void> cacheAppConnection(AppConnectionModel model);
  Future<bool> getAppConnectionUpdateStatus();
  Future<void> setAppConnectionUpdateStatus(bool update);
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

  @override
  Future<bool> getAppConnectionUpdateStatus() async {
    final data =
        sharedPreferences.getBool(SharedPreferencesKeys.appConnectionUpdate);
    if (data != null) {
      return data;
    } else {
      return true;
    }
  }

  @override
  Future<void> setAppConnectionUpdateStatus(bool update) async {
    sharedPreferences.setBool(
        SharedPreferencesKeys.appConnectionUpdate, update);
  }
}
