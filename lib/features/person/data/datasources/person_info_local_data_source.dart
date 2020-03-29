import 'dart:convert';

import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/person_info_model.dart';

abstract class PersonInfoLocalDataSource {
  Future<PersonInfoModel> getCachedPersonInfo();

  Future<void> cachePersonInfo(PersonInfoModel personInfoToCache);
}

const CACHE_PERSON_INFO = 'CACHE_PERSON_INFO';

class PersonInfoLocalDataSourceImpl implements PersonInfoLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonInfoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<PersonInfoModel> getCachedPersonInfo() async {
    final data = sharedPreferences.getString(CACHE_PERSON_INFO);
    if (data != null) {
      return Future.value(PersonInfoModel.fromJson(json.decode(data)));
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
