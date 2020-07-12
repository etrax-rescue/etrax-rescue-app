import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:flutter/material.dart';

class UserStatesModel extends UserStates {
  UserStatesModel({@required List<UserStateModel> states})
      : super(states: states);
}

class UserStateModel extends UserState {
  UserStateModel(
      {@required int id, @required String name, @required String description})
      : super(id: id, name: name, description: description);
}
