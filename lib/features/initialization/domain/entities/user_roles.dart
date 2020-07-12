import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserRoles extends Equatable {
  final List<UserRole> roles;

  UserRoles({
    @required this.roles,
  });

  @override
  List<Object> get props => [roles];
}

class UserRole extends Equatable {
  final int id;
  final String name;
  final String description;

  UserRole({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}
