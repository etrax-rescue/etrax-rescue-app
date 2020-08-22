import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/shared_preferences_keys.dart';
import '../../types/authentication_data.dart';
import '../../types/organizations.dart';

abstract class LocalAuthenticationDataSource {
  Future<void> cacheAuthenticationData(AuthenticationData model);

  Future<AuthenticationData> getCachedAuthenticationData();

  Future<void> deleteAuthenticationData();

  Future<void> cacheOrganizations(OrganizationCollection model);

  Future<OrganizationCollection> getCachedOrganizations();
}

class LocalAuthenticationDataSourceImpl
    implements LocalAuthenticationDataSource {
  final SharedPreferences sharedPreferences;
  LocalAuthenticationDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAuthenticationData(AuthenticationData model) async {
    sharedPreferences.setString(
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
    sharedPreferences.remove(SharedPreferencesKeys.authenticationData);
  }

  @override
  Future<void> cacheOrganizations(OrganizationCollection model) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.organizations, json.encode(model.toJson()));
  }

  @override
  Future<OrganizationCollection> getCachedOrganizations() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.organizations);
    if (data == null) {
      throw CacheException();
    }
    return OrganizationCollection.fromJson(json.decode(data));
  }
}
