import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/initialization_data.dart';
import 'package:flutter/material.dart';

import 'app_settings_model.dart';
import 'missions_model.dart';
import 'user_roles_model.dart';
import 'user_states_model.dart';

class InitializationDataModel extends InitializationData {
  final AppSettingsModel appSettingsModel;
  final MissionCollectionModel missionCollectionModel;
  final UserStateCollectionModel userStateCollectionModel;
  final UserRoleCollectionModel userRoleCollectionModel;

  InitializationDataModel({
    @required this.appSettingsModel,
    @required this.missionCollectionModel,
    @required this.userStateCollectionModel,
    @required this.userRoleCollectionModel,
  });

  @override
  List<Object> get props => [
        appSettingsModel,
        missionCollectionModel,
        userStateCollectionModel,
        userRoleCollectionModel
      ];
}
