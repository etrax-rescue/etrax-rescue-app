import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MissionCollection extends Equatable {
  MissionCollection({@required this.missions});

  final List<Mission> missions;

  factory MissionCollection.fromJson(Map<String, dynamic> json) {
    List<Mission> missionModelList;
    try {
      Iterable it = json['missions'];
      missionModelList =
          List<Mission>.from(it.map((el) => Mission.fromJson(el)).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return MissionCollection(missions: missionModelList);
  }

  Map<String, dynamic> toJson() {
    final jsonList = List<Map<String, dynamic>>.from(missions
        .map((e) => e is Mission ? e.toJson() : throw FormatException())
        .toList());
    return {
      'missions': jsonList,
    };
  }

  @override
  List<Object> get props => [missions];
}

class Mission extends Equatable {
  Mission({
    @required this.id,
    @required this.name,
    @required this.start,
    @required this.latitude,
    @required this.longitude,
    this.exercise = false,
  });

  final int id;
  final String name;
  final DateTime start;
  final double latitude;
  final double longitude;
  final bool exercise;

  factory Mission.fromJson(Map<String, dynamic> json) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(json['start']);
    } on ArgumentError {
      throw FormatException();
    }
    return Mission(
      id: json['id'] == null ? throw FormatException() : json['id'],
      name: json['name'] == null ? throw FormatException() : json['name'],
      start: dateTime,
      latitude: json['latitude'] == null || json['longitude'] == null
          ? null
          : json['latitude'],
      longitude: json['latitude'] == null || json['longitude'] == null
          ? null
          : json['longitude'],
      exercise: json['exercise'] == null ? false : json['exercise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'start': this.start.toIso8601String(),
      'latitude': this.latitude,
      'longitude': this.longitude,
      'exercise': this.exercise,
    };
  }

  @override
  List<Object> get props => [id, name, start, latitude, longitude, exercise];
}
