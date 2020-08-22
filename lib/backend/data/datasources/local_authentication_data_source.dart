import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/types/shared_preferences_keys.dart';
import '../models/authentication_data_model.dart';
import '../models/organizations_model.dart';

abstract class LocalAuthenticationDataSource {
  Future<void> cacheAuthenticationData(AuthenticationDataModel model);

  Future<AuthenticationDataModel> getCachedAuthenticationData();

  Future<void> deleteAuthenticationData();

  Future<void> cacheOrganizations(OrganizationCollectionModel model);

  Future<OrganizationCollectionModel> getCachedOrganizations();
}

class LocalAuthenticationDataSourceImpl
    implements LocalAuthenticationDataSource {
  final SharedPreferences sharedPreferences;
  LocalAuthenticationDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheAuthenticationData(AuthenticationDataModel model) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.authenticationData, json.encode(model.toJson()));
  }

  @override
  Future<AuthenticationDataModel> getCachedAuthenticationData() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.authenticationData);
    if (data == null) {
      throw CacheException();
    }
    return AuthenticationDataModel.fromJson(json.decode(data));
  }

  @override
  Future<void> deleteAuthenticationData() async {
    sharedPreferences.remove(SharedPreferencesKeys.authenticationData);
  }

  @override
  Future<void> cacheOrganizations(OrganizationCollectionModel model) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.organizations, json.encode(model.toJson()));
  }

  @override
  Future<OrganizationCollectionModel> getCachedOrganizations() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.organizations);
    if (data == null) {
      throw CacheException();
    }
    return OrganizationCollectionModel.fromJson(json.decode(data));
  }
}
