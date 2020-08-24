import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'app_connection.dart';
import 'authentication_data.dart';
import 'missions.dart';
import 'organizations.dart';
import 'user_roles.dart';
import 'user_states.dart';

class AppState extends Equatable {
  final AppConnection appConnection;

  final DateTime lastLogin;

  // We store the username here so that we can automatically populate the field
  // when the user enters the login page
  final String username;

  // We store the selected organization here so that we can automatically
  // select the corresponding dropdown item when the user enters the login page.
  final Organization selectedOrganization;

  // Also the authentication data is stored here, so we can have a pure login
  // flow that does not have to be concerned with storing the auth data.
  final AuthenticationData authenticationData;

  // Selected Mission, Role and State are also stored here
  final Mission selectedMission;
  final UserState selectedUserState;
  final UserRole selectedUserRole;

  AppState({
    @required this.appConnection,
    this.username,
    this.selectedOrganization,
    this.lastLogin,
    this.authenticationData,
    this.selectedUserState,
    this.selectedUserRole,
    this.selectedMission,
  });

  @override
  List<Object> get props => [
        appConnection,
        username,
        selectedOrganization,
        lastLogin,
        selectedUserState,
        selectedUserRole,
        selectedMission,
      ];
}
