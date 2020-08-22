import 'package:flutter/material.dart';

import '../../domain/entities/user_roles.dart';

class UserRoleCollectionModel extends UserRoleCollection {
  UserRoleCollectionModel({@required List<UserRoleModel> roles})
      : super(roles: roles);
  factory UserRoleCollectionModel.fromJson(Map<String, dynamic> json) {
    List<UserRoleModel> userRoleModelList;
    try {
      Iterable it = json['roles'];
      userRoleModelList = List<UserRoleModel>.from(
          it.map((el) => UserRoleModel.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return UserRoleCollectionModel(roles: userRoleModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(roles
        .map((e) => e is UserRoleModel ? e.toJson() : throw FormatException())
        .toList());
    return {
      'roles': jsonList,
    };
  }
}

class UserRoleModel extends UserRole {
  UserRoleModel(
      {@required int id, @required String name, @required String description})
      : super(id: id, name: name, description: description);

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
        id: json['id'] == null ? throw FormatException() : json['id'],
        name: json['name'] == null ? throw FormatException() : json['name'],
        description: json['description'] == null ? '' : json['description']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
    };
  }
}
