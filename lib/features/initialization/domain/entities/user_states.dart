import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserStates extends Equatable {
  final List<UserState> states;

  UserStates({
    @required this.states,
  });

  @override
  List<Object> get props => [states];
}

class UserState extends Equatable {
  final int id;
  final String name;
  final String description;

  UserState({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}
