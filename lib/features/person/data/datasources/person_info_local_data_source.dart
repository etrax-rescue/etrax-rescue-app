import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/shared_preferences_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../models/person_info_model.dart';

abstract class PersonInfoLocalDataSource {
  Future<PersonInfoModel> getCachedPersonInfo();

  Future<void> cachePersonInfo(PersonInfoModel personInfoToCache);
}

class PersonInfoLocalDataSourceImpl implements PersonInfoLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonInfoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<PersonInfoModel> getCachedPersonInfo() async {
    final data = sharedPreferences.getString(CACHE_PERSON_INFO);
    if (data != null) {
      return PersonInfoModel.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePersonInfo(PersonInfoModel personInfoToCache) {
    return sharedPreferences.setString(
        CACHE_PERSON_INFO, json.encode(personInfoToCache.toJson()));
  }
}
