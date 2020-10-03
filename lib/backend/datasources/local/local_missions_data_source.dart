import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/missions.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalMissionsDataSource {
  Future<void> insertMissions(MissionCollection missions);

  Future<MissionCollection> getMissions();

  Future<void> clearMissions();
}

class LocalMissionsDataSourceImpl implements LocalMissionsDataSource {
  LocalMissionsDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<void> clearMissions() async {
    await sharedPreferences.remove(SharedPreferencesKeys.missions);
  }

  @override
  Future<MissionCollection> getMissions() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.missions);
    if (data != null) {
      return MissionCollection.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> insertMissions(MissionCollection missions) async {
    Map<String, dynamic> jsonMap = missions.toJson();
    sharedPreferences.setString(
        SharedPreferencesKeys.missions, json.encode(jsonMap));
  }
}
