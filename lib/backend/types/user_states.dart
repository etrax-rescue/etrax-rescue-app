import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserStateCollection extends Equatable {
  UserStateCollection({
    @required this.states,
  });

  final List<UserState> states;

  factory UserStateCollection.fromJson(Map<String, dynamic> json) {
    List<UserState> userStateModelList;
    try {
      Iterable it = json['states'];
      userStateModelList =
          List<UserState>.from(it.map((el) => UserState.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return UserStateCollection(states: userStateModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(states
        .map((e) => e is UserState ? e.toJson() : throw FormatException())
        .toList());
    return {
      'states': jsonList,
    };
  }

  @override
  List<Object> get props => [states];
}

class UserState extends Equatable {
  UserState({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.locationAccuracy,
  });

  final int id;
  final String name;
  final String description;
  final int locationAccuracy;

  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
        id: json['id'] == null ? throw FormatException() : json['id'],
        name: json['name'] == null ? throw FormatException() : json['name'],
        description: json['description'] == null ? '' : json['description'],
        locationAccuracy: json['locationAccuracy'] == null
            ? throw FormatException()
            : json['locationAccuracy']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'locationAccuracy': this.locationAccuracy,
    };
  }

  @override
  List<Object> get props => [id, name, description, locationAccuracy];
}
