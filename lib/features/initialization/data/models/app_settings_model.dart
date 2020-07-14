import 'package:etrax_rescue_app/features/initialization/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

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
