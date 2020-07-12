import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_roles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tID = 42;
  final tName = 'operator';
  final tDescription = 'the one who is doing something';
  final tUserRoleModel =
      UserRoleModel(id: tID, name: tName, description: tDescription);
  final tUserRolesModel =
      UserRolesModel(roles: <UserRoleModel>[tUserRoleModel]);

  test(
    'should be a subclass of Missions entity',
    () async {
      // assert
      expect(tUserRolesModel, isA<UserRoles>());
    },
  );
}
