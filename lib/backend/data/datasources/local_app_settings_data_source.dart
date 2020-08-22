import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/shared_preferences_keys.dart';
import '../../types/app_configuration.dart';
import '../../types/app_connection.dart';

abstract class LocalAppSettingsDataSource {
  // App Connection
  Future<AppConnection> getCachedAppConnection();

  Future<void> cacheAppConnection(AppConnection model);

  Future<bool> getAppConnectionUpdateStatus();

  Future<void> setAppConnectionUpdateStatus(bool update);

  // App Configuration
  Future<void> storeAppConfiguration(AppConfiguration configuration);

  Future<AppConfiguration> getAppConfiguration();

  Future<void> clearAppConfiguration();
}

class LocalAppSettingsDataSourceImpl implements LocalAppSettingsDataSource {
  final SharedPreferences sharedPreferences;
  LocalAppSettingsDataSourceImpl(this.sharedPreferences);

  // App Connection
  @override
  Future<void> cacheAppConnection(AppConnection model) async {
    sharedPreferences.setString(
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

  // App Configuration
  @override
  Future<AppConfiguration> getAppConfiguration() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.appConfiguration);
    if (data != null) {
      return AppConfiguration.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeAppConfiguration(AppConfiguration configuration) async {
    sharedPreferences.setString(SharedPreferencesKeys.appConfiguration,
        json.encode(configuration.toJson()));
  }

  @override
  Future<void> clearAppConfiguration() async {
    // TODO: implement clearAppSettings
    throw UnimplementedError();
  }
}
