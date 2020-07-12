import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Mission extends Equatable {
  final String missionID;
  final String missionName;
  final DateTime missionStart;

  Mission({
    @required this.missionID,
    @required this.missionName,
    @required this.missionStart,
  });

  @override
  List<Object> get props => [missionID, missionName, missionStart];
}
