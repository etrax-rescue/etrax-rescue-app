import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class SearchAreaCollection extends Equatable {
  SearchAreaCollection({@required this.areas});

  final List<SearchArea> areas;

  factory SearchAreaCollection.fromJson(List<dynamic> json) {
    List<SearchArea> searchAreaList;
    try {
      Iterable it = json;
      searchAreaList = List<SearchArea>.from(it.map((el) {
        return SearchArea.fromJson(el);
      }).toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return SearchAreaCollection(areas: searchAreaList);
  }

  @override
  List<Object> get props => [areas];
}

// Based on https://stackoverflow.com/a/50382196
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class SearchArea extends Equatable {
  SearchArea({
    @required this.label,
    @required this.id,
    @required this.coordinates,
    @required this.description,
    @required this.color,
  });

  final List<LatLng> coordinates;
  final String id;
  final String label;
  final String description;
  final Color color;

  factory SearchArea.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['coordinates'] == null)
      throw FormatException();

    List<LatLng> coordinates = [];
    try {
      Iterable it = json['coordinates'];
      coordinates = List<LatLng>.from(it
          .map((el) => LatLng(el[1] is String ? double.parse(el[1]) : el[1],
              el[0] is String ? double.parse(el[0]) : el[0]))
          .toList());
    } on NoSuchMethodError {
      throw FormatException();
    } on TypeError {
      throw FormatException();
    }
    return SearchArea(
        id: json['id'] == null ? throw FormatException() : json['id'],
        label: json['label'] == null ? throw FormatException() : json['label'],
        description: json['description'] == null
            ? throw FormatException()
            : json['description'],
        coordinates: coordinates,
        color: json['color'] == null ? null : hexToColor(json['color']));
  }

  @override
  List<Object> get props => [id, label, description, coordinates];
}
