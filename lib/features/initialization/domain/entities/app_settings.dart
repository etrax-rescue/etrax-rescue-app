import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  final int locationUpdateInterval;

  AppSettings({
    @required this.locationUpdateInterval,
  });

  @override
  List<Object> get props => [locationUpdateInterval];
}
