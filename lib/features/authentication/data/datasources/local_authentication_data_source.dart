import 'dart:convert';
import 'package:etrax_rescue_app/core/shared_preferences_keys.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalAuthenticationDataSource {
  Future<void> cacheAuthenticationData(AuthenticationDataModel model);

  Future<AuthenticationDataModel> getCachedAuthenticationData();

  Future<void> deleteAuthenticationData();
}

class LocalAuthenticationDataSourceImpl
    implements LocalAuthenticationDataSource {
  final SharedPreferences sharedPreferences;
  LocalAuthenticationDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAuthenticationData(AuthenticationDataModel model) async {
    sharedPreferences.setString(
        CACHE_AUTHENTICATION_DATA, json.encode(model.toJson()));
  }

  @override
  Future<AuthenticationDataModel> getCachedAuthenticationData() async {
    final data = sharedPreferences.getString(CACHE_AUTHENTICATION_DATA);
    if (data == null) {
      throw CacheException();
    }
    return AuthenticationDataModel.fromJson(json.decode(data));
  }

  @override
  Future<void> deleteAuthenticationData() async {
    sharedPreferences.remove(CACHE_AUTHENTICATION_DATA);
  }
}
