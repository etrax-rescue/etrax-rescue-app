import '../../types/missions.dart';
import '../../types/user_roles.dart';
import '../../types/user_states.dart';

abstract class LocalAppStateDataSource {
  Future<void> cacheSelectedMission(Mission mission);
  Future<Mission> getCachedSelectedMission();
  Future<void> deleteSelectedMission();

  Future<void> cacheSelectedUserState(UserState state);
  Future<UserState> getCachedSelectedUserState();
  Future<void> deleteCachedSelectedUserState();

  Future<void> cacheSelectedUserRole(UserRole role);
  Future<UserRole> getCachedSelectedUserRole();
  Future<void> deleteUserRole();

  Future<void> cacheUsername(String username);
  Future<String> getCachedUsername();
  Future<void> deleteUsername();

  Future<void> cacheLastLoginTime(DateTime lastLoginTime);
  Future<DateTime> getCachedLastLoginTime();
  Future<void> deleteLastLoginTime();
}
