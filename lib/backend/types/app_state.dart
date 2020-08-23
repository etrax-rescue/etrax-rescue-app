import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:flutter/material.dart';

import 'missions.dart';
import 'user_roles.dart';
import 'user_states.dart';

class AppState extends Equatable {
  final DateTime lastLogin;
  final AuthenticationData authenticationData;
  final UserState selectedUserState;
  final UserRole selectedUserRole;
  final Mission selectedMission;

  AppState({
    @required this.lastLogin,
    @required this.authenticationData,
    @required this.selectedUserState,
    @required this.selectedUserRole,
    @required this.selectedMission,
  });

  @override
  List<Object> get props =>
      [lastLogin, selectedUserState, selectedUserRole, selectedMission];
}
