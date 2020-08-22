import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  AppSettingsModel(
      {@required int locationUpdateInterval,
      @required int locationUpdateMinDistance,
      @required int infoUpdateInterval})
      : super(
            locationUpdateInterval: locationUpdateInterval,
            locationUpdateMinDistance: locationUpdateMinDistance,
            infoUpdateInterval: infoUpdateInterval);

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
        locationUpdateInterval: json['locationUpdateInterval'],
        locationUpdateMinDistance: json['locationUpdateMinDistance'],
        infoUpdateInterval: json['infoUpdateInterval']);
  }

  Map<String, dynamic> toJson() {
    return {
      'locationUpdateInterval': locationUpdateInterval,
      'locationUpdateMinDistance': locationUpdateMinDistance,
      'infoUpdateInterval': infoUpdateInterval,
    };
  }
}
