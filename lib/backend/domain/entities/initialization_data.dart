import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'app_settings.dart';
import 'missions.dart';
import 'user_roles.dart';
import 'user_states.dart';

class InitializationData extends Equatable {
  final AppSettings appSettings;
  final MissionCollection missionCollection;
  final UserStateCollection userStateCollection;
  final UserRoleCollection userRoleCollection;

  InitializationData({
    @required this.appSettings,
    @required this.missionCollection,
    @required this.userStateCollection,
    @required this.userRoleCollection,
  });

  @override
  List<Object> get props =>
      [appSettings, missionCollection, userStateCollection, userRoleCollection];
}
