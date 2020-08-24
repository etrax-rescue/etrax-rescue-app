import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/app_configuration.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalAppConfigurationDataSource {
  // App Configuration
  Future<void> setAppConfiguration(AppConfiguration configuration);

  Future<AppConfiguration> getAppConfiguration();

  Future<void> deleteAppConfiguration();
}

class LocalAppConfigurationDataSourceImpl
    implements LocalAppConfigurationDataSource {
  final SharedPreferences sharedPreferences;
  LocalAppConfigurationDataSourceImpl(this.sharedPreferences);

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
  Future<void> setAppConfiguration(AppConfiguration configuration) async {
    sharedPreferences.setString(SharedPreferencesKeys.appConfiguration,
        json.encode(configuration.toJson()));
  }

  @override
  Future<void> deleteAppConfiguration() async {
    // TODO: implement clearAppSettings
    throw UnimplementedError();
  }
}
