import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/shared_preferences_keys.dart';
import '../../types/missions.dart';

abstract class LocalMissionsDataSource {
  Future<void> insertMissions(MissionCollection missions);

  Future<void> updateMission(Mission mission);

  Future<MissionCollection> getMissions();

  Future<void> clearMissions();
}

class LocalMissionsDataSourceImpl implements LocalMissionsDataSource {
  final SharedPreferences sharedPreferences;
  LocalMissionsDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> clearMissions() async {
    // TODO: implement clearMissions
    throw UnimplementedError();
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

  @override
  Future<void> updateMission(Mission mission) async {
    // TODO: implement updateMission
    throw UnimplementedError();
  }
}
