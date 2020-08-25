import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/missions.dart';
import '../../types/shared_preferences_keys.dart';
import '../../types/user_roles.dart';
import '../../types/user_states.dart';

abstract class LocalMissionStateDataSource {
  Future<void> cacheSelectedMission(Mission mission);
  Future<Mission> getCachedSelectedMission();

  Future<void> cacheSelectedUserState(UserState state);
  Future<UserState> getCachedSelectedUserState();

  Future<void> cacheSelectedUserRole(UserRole role);
  Future<UserRole> getCachedSelectedUserRole();

  Future<void> clear();
}

class LocalMissionStateDataSourceImpl implements LocalMissionStateDataSource {
  final SharedPreferences sharedPreferences;
  LocalMissionStateDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheSelectedMission(Mission mission) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.selectedMission, json.encode(mission.toJson()));
  }

  @override
  Future<Mission> getCachedSelectedMission() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.selectedMission);
    if (data != null) {
      return Mission.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSelectedUserState(UserState state) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.selectedUserState, json.encode(state.toJson()));
  }

  @override
  Future<UserState> getCachedSelectedUserState() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.selectedUserState);
    if (data != null) {
      return UserState.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSelectedUserRole(UserRole role) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.selectedUserRole, json.encode(role.toJson()));
  }

  @override
  Future<UserRole> getCachedSelectedUserRole() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.selectedUserRole);
    if (data != null) {
      return UserRole.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.remove(SharedPreferencesKeys.selectedMission);
    await sharedPreferences.remove(SharedPreferencesKeys.selectedUserRole);
    await sharedPreferences.remove(SharedPreferencesKeys.selectedUserState);
  }
}
