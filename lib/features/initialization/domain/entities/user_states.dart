import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserStateCollection extends Equatable {
  final List<UserState> states;

  UserStateCollection({
    @required this.states,
  });

  @override
  List<Object> get props => [states];
}

class UserState extends Equatable {
  final int id;
  final String name;
  final String description;
  final int locationAccuracy;

  UserState({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.locationAccuracy,
  });

  @override
  List<Object> get props => [id, name, description, locationAccuracy];
}
