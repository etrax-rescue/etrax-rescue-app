import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/authentication_data.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalAuthenticationDataSource {
  Future<void> cacheAuthenticationData(AuthenticationData model);

  Future<AuthenticationData> getCachedAuthenticationData();

  Future<void> deleteAuthenticationData();
}

class LocalAuthenticationDataSourceImpl
    implements LocalAuthenticationDataSource {
  final SharedPreferences sharedPreferences;
  LocalAuthenticationDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAuthenticationData(AuthenticationData model) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.authenticationData, json.encode(model.toJson()));
  }

  @override
  Future<AuthenticationData> getCachedAuthenticationData() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.authenticationData);
    if (data == null) {
      throw CacheException();
    }
    return AuthenticationData.fromJson(json.decode(data));
  }

  @override
  Future<void> deleteAuthenticationData() async {
    await sharedPreferences.remove(SharedPreferencesKeys.authenticationData);
  }
}
