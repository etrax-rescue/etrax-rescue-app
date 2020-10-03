import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/organizations.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalOrganizationsDataSource {
  Future<void> cacheOrganizations(OrganizationCollection model);
  Future<OrganizationCollection> getCachedOrganizations();
  Future<void> deleteCachedOrganizations();
}

class LocalOrganizationsDataSourceImpl implements LocalOrganizationsDataSource {
  LocalOrganizationsDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheOrganizations(OrganizationCollection model) async {
    await sharedPreferences.setString(
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

  @override
  Future<void> deleteCachedOrganizations() async {
    await sharedPreferences.remove(SharedPreferencesKeys.organizations);
  }
}
