import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:flutter/material.dart';

class MissionCollectionModel extends MissionCollection {
  MissionCollectionModel({@required List<MissionModel> missions})
      : super(missions: missions);

  factory MissionCollectionModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

class MissionModel extends Mission {
  MissionModel({
    @required String id,
    @required String name,
    @required DateTime start,
    @required double latitude,
    @required double longitude,
  }) : super(
            id: id,
            name: name,
            start: start,
            latitude: latitude,
            longitude: longitude);
}
