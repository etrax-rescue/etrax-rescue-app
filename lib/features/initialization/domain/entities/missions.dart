import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MissionCollection extends Equatable {
  final List<Mission> missions;

  MissionCollection({
    @required this.missions,
  });

  @override
  List<Object> get props => [missions];
}

class Mission extends Equatable {
  final int id;
  final String name;
  final DateTime start;
  final double latitude;
  final double longitude;

  Mission({
    @required this.id,
    @required this.name,
    @required this.start,
    @required this.latitude,
    @required this.longitude,
  });

  @override
  List<Object> get props => [id, name, start, latitude, longitude];
}
