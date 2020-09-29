import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/quick_actions.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalQuickActionDataSource {
  Future<void> storeQuickActions(QuickActionCollection actions);

  Future<QuickActionCollection> getQuickActions();

  Future<void> clearQuickActions();
}

class LocalQuickActionDataSourceImpl implements LocalQuickActionDataSource {
  final SharedPreferences sharedPreferences;
  LocalQuickActionDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> clearQuickActions() async {
    await sharedPreferences.remove(SharedPreferencesKeys.quickActions);
  }

  @override
  Future<QuickActionCollection> getQuickActions() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.quickActions);
    if (data != null) {
      return QuickActionCollection.fromJson(json.decode(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> storeQuickActions(QuickActionCollection actions) async {
    sharedPreferences.setString(
        SharedPreferencesKeys.quickActions, json.encode(actions.toJson()));
  }
}
