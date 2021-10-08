import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../types/shared_preferences_keys.dart';

abstract class LocalLoginDataSource {
  Future<void> cacheUsername(String username);
  Future<String> getCachedUsername();

  Future<void> cacheSelectedOrganizationID(String organizationID);
  Future<String> getCachedSelectedOrganizationID();

  Future<void> cacheExpirationDate(DateTime expirationDate);
  Future<DateTime> getCachedExpirationDate();

  Future<void> cacheToken(String token);
  Future<String> getCachedToken();
  Future<void> deleteToken();
}

class LocalLoginDataSourceImpl implements LocalLoginDataSource {
  LocalLoginDataSourceImpl(this.sharedPreferences, this.secureStorage);

  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheUsername(String username) async {
    await sharedPreferences.setString(SharedPreferencesKeys.username, username);
  }

  @override
  Future<String> getCachedUsername() async {
    final data = sharedPreferences.getString(SharedPreferencesKeys.username);
    if (data != null) {
      return data;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheSelectedOrganizationID(String organizationID) async {
    await sharedPreferences.setString(
        SharedPreferencesKeys.selectedOrganization, organizationID);
  }

  @override
  Future<String> getCachedSelectedOrganizationID() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.selectedOrganization);
    if (data != null) {
      return data;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheExpirationDate(DateTime expirationDate) async {
    await sharedPreferences.setString(SharedPreferencesKeys.expirationDate,
        expirationDate.millisecondsSinceEpoch.toString());
  }

  @override
  Future<DateTime> getCachedExpirationDate() async {
    final data =
        sharedPreferences.getString(SharedPreferencesKeys.expirationDate);
    if (data != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    await secureStorage.write(key: SharedPreferencesKeys.token, value: token);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: SharedPreferencesKeys.token);
  }

  @override
  Future<String> getCachedToken() async {
    final data = await secureStorage.read(key: SharedPreferencesKeys.token);
    if (data != null) {
      return data;
    } else {
      return '';
    }
  }
}
