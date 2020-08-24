import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/shared_preferences_keys.dart';
import '../../types/user_states.dart';

abstract class LocalUserStatesDataSource {
  Future<void> storeUserStates(UserStateCollection states);

  Future<UserStateCollection> getUserStates();

  Future<void> clearUserStates();
}

class LocalUserStatesDataSourceImpl implements LocalUserStatesDataSource {
  final SharedPreferences sharedPreferences;
  LocalUserStatesDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> clearUserStates() async {
    // TODO: implement clearUserStates
    throw UnimplementedError();
  }

  @override
  Future<UserStateCollection> getUserStates() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.userStates);
    if (data != null) {
      return UserStateCollection.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeUserStates(UserStateCollection states) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.userStates, json.encode(states.toJson()));
  }
}
