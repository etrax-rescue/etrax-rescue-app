import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'app_configuration.dart';
import 'missions.dart';
import 'user_roles.dart';
import 'user_states.dart';

class InitializationData extends Equatable {
  final AppConfiguration appConfiguration;
  final MissionCollection missionCollection;
  final UserStateCollection userStateCollection;
  final UserRoleCollection userRoleCollection;

  InitializationData({
    @required this.appConfiguration,
    @required this.missionCollection,
    @required this.userStateCollection,
    @required this.userRoleCollection,
  });

  factory InitializationData.fromJson(Map<String, dynamic> json) {
    final appConfiguration =
        AppConfiguration.fromJson(json['appConfiguration']);
    final missionCollection = MissionCollection.fromJson(json);
    final userRoleCollection = UserRoleCollection.fromJson(json);
    final userStateCollection = UserStateCollection.fromJson(json);
    return InitializationData(
        appConfiguration: appConfiguration,
        missionCollection: missionCollection,
        userRoleCollection: userRoleCollection,
        userStateCollection: userStateCollection);
  }

  @override
  List<Object> get props => [
        appConfiguration,
        missionCollection,
        userStateCollection,
        userRoleCollection
      ];
}
