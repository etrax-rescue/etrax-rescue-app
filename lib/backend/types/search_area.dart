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

class SearchArea extends Equatable {
  SearchArea({
    @required this.label,
    @required this.id,
    @required this.coordinates,
    @required this.description,
  });

  final List<LatLng> coordinates;
  final String id;
  final String label;
  final String description;

  factory SearchArea.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['coordinates'] == null)
      throw FormatException();

    List<LatLng> coordinates = [];
    try {
      Iterable it = json['coordinates'];
      coordinates =
          List<LatLng>.from(it.map((el) => LatLng(el[1], el[0])).toList());
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
    );
  }

  @override
  List<Object> get props => [id, label, description, coordinates];
}
