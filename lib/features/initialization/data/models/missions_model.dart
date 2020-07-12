import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter/material.dart';

class MissionsModel extends Missions {
  MissionsModel({@required List<MissionModel> missions})
      : super(missions: missions);
}

class MissionModel extends Mission {
  MissionModel(
      {@required String missionID,
      @required String missionName,
      @required DateTime missionStart})
      : super(
            missionID: missionID,
            missionName: missionName,
            missionStart: missionStart);
}
