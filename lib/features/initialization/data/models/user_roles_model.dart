import 'package:etrax_rescue_app/features/initialization/domain/entities/user_roles.dart';
import 'package:flutter/material.dart';

class UserRoleCollectionModel extends UserRoleCollection {
  UserRoleCollectionModel({@required List<UserRoleModel> roles})
      : super(roles: roles);
  factory UserRoleCollectionModel.fromJson(Map<String, dynamic> json) {
    List<UserRoleModel> userRoleList = [];
    try {
      final Map<String, dynamic> roles = json['roles'];
      roles.forEach((key, value) {
        int id = int.tryParse(key);
        String name;
        String description = '';
        value.forEach((k, v) {
          if (k == 'name') {
            name = v;
          } else if (k == 'description') {
            description = v;
          }
        });
        if (name == null) {
          throw FormatException();
        }
        userRoleList
            .add(UserRoleModel(id: id, name: name, description: description));
      });
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return UserRoleCollectionModel(roles: userRoleList);
  }
}

class UserRoleModel extends UserRole {
  UserRoleModel(
      {@required int id, @required String name, @required String description})
      : super(id: id, name: name, description: description);
}
