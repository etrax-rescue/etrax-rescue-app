import '../models/user_roles_model.dart';

abstract class LocalUserRolesDataSource {
  Future<void> storeUserRoles(UserRolesModel roles);

  Future<UserRolesModel> getUserRoles();

  Future<void> clearUserRoles();
}
