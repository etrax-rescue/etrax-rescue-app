import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/types/shared_preferences_keys.dart';
import '../models/app_settings_model.dart';

abstract class LocalAppSettingsDataSource {
  Future<void> storeAppSettings(AppSettingsModel settings);

  Future<AppSettingsModel> getAppSettings();

  Future<void> clearAppSettings();
}

class LocalAppSettingsDataSourceImpl implements LocalAppSettingsDataSource {
  final SharedPreferences sharedPreferences;
  LocalAppSettingsDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> clearAppSettings() async {
    // TODO: implement clearAppSettings
    throw UnimplementedError();
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.appSettings);
    if (data != null) {
      return AppSettingsModel.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeAppSettings(AppSettingsModel settings) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.appSettings, json.encode(settings.toJson()));
  }
}
