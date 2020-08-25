import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'missions.dart';
import 'user_roles.dart';
import 'user_states.dart';

class MissionState extends Equatable {
  final Mission mission;
  final UserState state;
  final UserRole role;

  MissionState(
      {@required this.mission, @required this.state, @required this.role});

  @override
  List<Object> get props => [mission, state, role];
}
