import 'package:equatable/equatable.dart';

class AppConfiguration extends Equatable {
  AppConfiguration({
    required this.locationUpdateInterval,
    required this.locationUpdateMinDistance,
    required this.infoUpdateInterval,
  });

  final int locationUpdateInterval;
  final int locationUpdateMinDistance;
  final int infoUpdateInterval;

  factory AppConfiguration.fromJson(Map<String, dynamic> json) {
    return AppConfiguration(
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

  @override
  List<Object> get props =>
      [locationUpdateInterval, locationUpdateMinDistance, infoUpdateInterval];
}
