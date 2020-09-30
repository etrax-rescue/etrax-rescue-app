import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class SearchAreaCollection extends Equatable {
  SearchAreaCollection({@required this.areas});

  final List<SearchArea> areas;

  @override
  List<Object> get props => [areas];
}

class SearchArea extends Equatable {
  SearchArea({@required this.coordinates});

  final List<LatLng> coordinates;

  @override
  List<Object> get props => [coordinates];
}
