// @dart=2.9
import 'package:background_location/background_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Poi extends Equatable {
  Poi({@required this.locationData, @required this.imagePath, this.description})
      : super();

  final LocationData locationData;
  final String imagePath;
  final String description;

  @override
  List<Object> get props => [locationData, imagePath, description];
}
