import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/initialization_data.dart';
import 'package:flutter/material.dart';

import 'app_settings_model.dart';
import 'missions_model.dart';
import 'user_roles_model.dart';
import 'user_states_model.dart';

class InitializationDataModel extends InitializationData {
  InitializationDataModel({
    @required AppSettingsModel appSettings,
    @required MissionCollectionModel missionCollection,
    @required UserStateCollectionModel userStateCollection,
    @required UserRoleCollectionModel userRoleCollection,
  }) : super(
            appSettings: appSettings,
            missionCollection: missionCollection,
            userStateCollection: userStateCollection,
            userRoleCollection: userRoleCollection);

  @override
  List<Object> get props => [
        appSettings,
        missionCollection,
        userStateCollection,
        userRoleCollection,
      ];
}
