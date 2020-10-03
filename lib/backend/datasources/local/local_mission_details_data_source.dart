import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/mission_details.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalMissionDetailsDataSource {
  Future<void> cacheMissionDetails(MissionDetailCollection collection);
  Future<MissionDetailCollection> getCachedMissionDetails();
  Future<void> deleteCachedMissionDetails();
}

class LocalMissionDetailsDataSourceImpl
    implements LocalMissionDetailsDataSource {
  LocalMissionDetailsDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheMissionDetails(MissionDetailCollection collection) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.missionDetails, json.encode(collection.toJson()));
  }

  @override
  Future<MissionDetailCollection> getCachedMissionDetails() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.missionDetails);
    if (data == null) {
      throw CacheException();
    }
    return MissionDetailCollection.fromJson(json.decode(data));
  }

  @override
  Future<void> deleteCachedMissionDetails() async {
    await sharedPreferences.remove(SharedPreferencesKeys.missionDetails);
  }
}
