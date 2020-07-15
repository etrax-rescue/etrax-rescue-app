import 'package:flutter/material.dart';

import '../../domain/entities/missions.dart';

class MissionCollectionModel extends MissionCollection {
  MissionCollectionModel({@required List<MissionModel> missions})
      : super(missions: missions);

  factory MissionCollectionModel.fromJson(Map<String, dynamic> json) {
    List<MissionModel> missionModelList;
    try {
      Iterable it = json['missions'];
      missionModelList = List<MissionModel>.from(
          it.map((el) => MissionModel.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return MissionCollectionModel(missions: missionModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(missions
        .map((e) => e is MissionModel ? e.toJson() : throw FormatException())
        .toList());
    return {
      'missions': jsonList,
    };
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

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(json['start']);
    } on ArgumentError {
      throw FormatException();
    }
    return MissionModel(
      id: json['id'] == null ? throw FormatException() : json['id'],
      name: json['name'] == null ? throw FormatException() : json['name'],
      start: dateTime,
      latitude: json['latitude'] == null || json['longitude'] == null
          ? null
          : json['latitude'],
      longitude: json['latitude'] == null || json['longitude'] == null
          ? null
          : json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'start': this.start.toIso8601String(),
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }
}
