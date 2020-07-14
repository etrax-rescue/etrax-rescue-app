import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:flutter/material.dart';

class UserStateCollectionModel extends UserStateCollection {
  UserStateCollectionModel({@required List<UserStateModel> states})
      : super(states: states);

  factory UserStateCollectionModel.fromJson(Map<String, dynamic> json) {
    List<UserStateModel> userStateList = [];
    try {
      final Map<String, dynamic> roles = json['states'];
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
        userStateList
            .add(UserStateModel(id: id, name: name, description: description));
      });
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return UserStateCollectionModel(states: userStateList);
  }
}

class UserStateModel extends UserState {
  UserStateModel(
      {@required int id, @required String name, @required String description})
      : super(id: id, name: name, description: description);
}
