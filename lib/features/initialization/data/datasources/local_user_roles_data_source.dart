import '../models/user_roles_model.dart';

abstract class LocalUserRolesDataSource {
  Future<void> storeUserRoles(UserRoleCollectionModel roles);

  Future<UserRoleCollectionModel> getUserRoles();

  Future<void> clearUserRoles();
}
