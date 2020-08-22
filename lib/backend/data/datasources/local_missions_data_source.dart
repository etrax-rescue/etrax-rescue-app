import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/types/shared_preferences_keys.dart';
import '../models/missions_model.dart';

abstract class LocalMissionsDataSource {
  Future<void> insertMissions(MissionCollectionModel missions);

  Future<void> updateMission(MissionModel mission);

  Future<MissionCollectionModel> getMissions();

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
  Future<MissionCollectionModel> getMissions() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.missions);
    if (data != null) {
      return MissionCollectionModel.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> insertMissions(MissionCollectionModel missions) async {
    Map<String, dynamic> jsonMap = missions.toJson();
    sharedPreferences.setString(
        SharedPreferencesKeys.missions, json.encode(jsonMap));
  }

  @override
  Future<void> updateMission(MissionModel mission) async {
    // TODO: implement updateMission
    throw UnimplementedError();
  }
}
