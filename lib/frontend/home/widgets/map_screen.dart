import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../../generated/l10n.dart';
import '../bloc/home_bloc.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController;
  final GlobalKey _key = GlobalKey();
  bool centerButtonVisible = true;
  StreamSubscription<MapPosition> _streamSubscription;
  List<Marker> _markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        LatLng centerPosition;
        List<LatLng> points;
        if (state.locationHistory.length > 0) {
          centerPosition = LatLng(state.locationHistory.last.latitude,
              state.locationHistory.last.longitude);
          points = state.locationHistory
              .map((locationData) =>
                  LatLng(locationData.latitude, locationData.longitude))
              .toList();
        } else if (state.missionState != null) {
          centerPosition = LatLng(state.missionState.mission.latitude,
              state.missionState.mission.longitude);
          points = [];
        } else {
          centerPosition = LatLng(48.2084114, 16.3712767);
          points = [centerPosition];
        }

        if (_mapController.ready) {
          if (_mapController.center != null) {
            _streamSubscription?.cancel();
            _streamSubscription = _mapController.position.listen((position) {
              if (position.center != centerPosition) {
                setState(() {
                  centerButtonVisible = true;
                });
              }
            });
          }
        }

        _markers = [
          Marker(
            anchorPos: AnchorPos.align(AnchorAlign.top),
            point: state.missionState != null
                ? LatLng(state.missionState.mission.latitude,
                    state.missionState.mission.longitude)
                : centerPosition,
            builder: (ctx) => Container(
              child: Image.asset('assets/images/leitstelle.png'),
            ),
          ),
        ];

        if (state.locationHistory.length > 0) {
          _markers.add(Marker(
            point: centerPosition,
            builder: (ctx) => Container(
              child: Icon(Icons.my_location),
            ),
          ));
        }

        return Stack(
          children: [
            FlutterMap(
              key: _key,
              options: MapOptions(
                center: centerPosition,
                zoom: 12.0,
              ),
              mapController: _mapController,
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: CachedNetworkTileProvider(),
                ),
                MarkerLayerOptions(
                  markers: _markers,
                ),
                PolylineLayerOptions(
                  polylines: [
                    Polyline(
                      points: points,
                      color: Colors.red,
                      strokeWidth: 3,
                      isDotted: true,
                    )
                  ],
                )
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (_mapController.ready) {
                          if (_mapController.zoom != null) {
                            _mapController.move(
                                centerPosition, _mapController.zoom);
                            setState(() {
                              centerButtonVisible = false;
                            });
                          }
                        }
                      },
                      icon: Icon(
                        Icons.gps_fixed,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(S.of(context).CENTER,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      backgroundColor: Color.fromARGB(180, 255, 255, 255),
                    ),
                    visible: centerButtonVisible,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
