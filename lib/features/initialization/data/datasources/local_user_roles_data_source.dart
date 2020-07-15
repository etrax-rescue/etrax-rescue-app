import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/types/shared_preferences_keys.dart';
import '../models/user_roles_model.dart';

abstract class LocalUserRolesDataSource {
  Future<void> storeUserRoles(UserRoleCollectionModel roles);

  Future<UserRoleCollectionModel> getUserRoles();

  Future<void> clearUserRoles();
}

class LocalUserRolesDataSourceImpl implements LocalUserRolesDataSource {
  final SharedPreferences sharedPreferences;
  LocalUserRolesDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> clearUserRoles() async {
    // TODO: implement clearUserRoles
    throw UnimplementedError();
  }

  @override
  Future<UserRoleCollectionModel> getUserRoles() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.userRoles);
    if (data != null) {
      return UserRoleCollectionModel.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeUserRoles(UserRoleCollectionModel roles) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.userRoles, json.encode(roles.toJson()));
  }
}
