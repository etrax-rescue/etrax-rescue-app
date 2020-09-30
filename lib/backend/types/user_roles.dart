import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserRoleCollection extends Equatable {
  UserRoleCollection({
    @required this.roles,
  });

  final List<UserRole> roles;

  factory UserRoleCollection.fromJson(Map<String, dynamic> json) {
    List<UserRole> userRoleModelList;
    try {
      Iterable it = json['roles'];
      userRoleModelList =
          List<UserRole>.from(it.map((el) => UserRole.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return UserRoleCollection(roles: userRoleModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(roles
        .map((e) => e is UserRole ? e.toJson() : throw FormatException())
        .toList());
    return {
      'roles': jsonList,
    };
  }

  @override
  List<Object> get props => [roles];
}

class UserRole extends Equatable {
  UserRole({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  final int id;
  final String name;
  final String description;

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
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

  @override
  List<Object> get props => [id, name, description];
}
