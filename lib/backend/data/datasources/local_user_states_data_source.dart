import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/types/shared_preferences_keys.dart';
import '../models/user_states_model.dart';

abstract class LocalUserStatesDataSource {
  Future<void> storeUserStates(UserStateCollectionModel states);

  Future<UserStateCollectionModel> getUserStates();

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
  Future<UserStateCollectionModel> getUserStates() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.userStates);
    if (data != null) {
      return UserStateCollectionModel.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeUserStates(UserStateCollectionModel states) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.userStates, json.encode(states.toJson()));
  }
}
