import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  final int locationUpdateInterval;
  final int locationUpdateMinDistance;
  final int infoUpdateInterval;

  AppSettings({
    @required this.locationUpdateInterval,
    @required this.locationUpdateMinDistance,
    @required this.infoUpdateInterval,
  });

  @override
  List<Object> get props =>
      [locationUpdateInterval, locationUpdateMinDistance, infoUpdateInterval];
}
