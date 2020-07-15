import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
}

class UserStateModel extends UserState {
  UserStateModel(
      {@required int id, @required String name, @required String description})
      : super(id: id, name: name, description: description);

  factory UserStateModel.fromJson(Map<String, dynamic> json) {
    return UserStateModel(
        id: json['id'] == null ? throw FormatException() : json['id'],
        name: json['name'] == null ? throw FormatException() : json['name'],
        description: json['description'] == null ? '' : json['description']);
  }
}
