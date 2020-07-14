import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_roles_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:flutter/material.dart';

class InitializationDataModel {
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
}
