import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/shared_preferences_keys.dart';
import '../../types/user_roles.dart';

abstract class LocalUserRolesDataSource {
  Future<void> storeUserRoles(UserRoleCollection roles);

  Future<UserRoleCollection> getUserRoles();

  Future<void> clearUserRoles();
}

class LocalUserRolesDataSourceImpl implements LocalUserRolesDataSource {
  LocalUserRolesDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<void> clearUserRoles() async {
    await sharedPreferences.remove(SharedPreferencesKeys.userRoles);
  }

  @override
  Future<UserRoleCollection> getUserRoles() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.userRoles);
    if (data != null) {
      return UserRoleCollection.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeUserRoles(UserRoleCollection roles) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.userRoles, json.encode(roles.toJson()));
  }
}
