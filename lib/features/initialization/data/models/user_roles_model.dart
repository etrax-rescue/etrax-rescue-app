import 'package:etrax_rescue_app/features/initialization/domain/entities/user_roles.dart';
import 'package:flutter/material.dart';

class UserRolesModel extends UserRoles {
  UserRolesModel({@required List<UserRoleModel> roles}) : super(roles: roles);
}

class UserRoleModel extends UserRole {
  UserRoleModel(
      {@required int id, @required String name, @required String description})
      : super(id: id, name: name, description: description);
}
