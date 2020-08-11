import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_states.dart';

class UserStateCollectionModel extends UserStateCollection {
  UserStateCollectionModel({@required List<UserStateModel> states})
      : super(states: states);

  factory UserStateCollectionModel.fromJson(Map<String, dynamic> json) {
    List<UserStateModel> userStateModelList;
    try {
      Iterable it = json['states'];
      userStateModelList = List<UserStateModel>.from(
          it.map((el) => UserStateModel.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return UserStateCollectionModel(states: userStateModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(states
        .map((e) => e is UserStateModel ? e.toJson() : throw FormatException())
        .toList());
    return {
      'states': jsonList,
    };
  }
}

class UserStateModel extends UserState {
  UserStateModel(
      {@required int id,
      @required String name,
      @required String description,
      @required int locationAccuracy})
      : super(
            id: id,
            name: name,
            description: description,
            locationAccuracy: locationAccuracy);

  factory UserStateModel.fromJson(Map<String, dynamic> json) {
    return UserStateModel(
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
}
