import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  AppSettingsModel({@required int locationUpdateInterval})
      : super(locationUpdateInterval: locationUpdateInterval);

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
        locationUpdateInterval: json['locationUpdateInterval']);
  }

  Map<String, dynamic> toJson() {
    return {
      'locationUpdateInterval': locationUpdateInterval,
    };
  }
}
