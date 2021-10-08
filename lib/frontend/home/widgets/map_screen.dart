// @dart=2.9
import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../bloc/home_bloc.dart';

class CachedNetworkTileProvider extends TileProvider {
  const CachedNetworkTileProvider();

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(getTileUrl(coords, options));
  }
}

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController;
  bool centerButtonVisible = true;
  StreamSubscription<MapEvent> _streamSubscription;
  List<Marker> _markers = [];
  bool initiallyCentered = false;
  LatLng centerPosition;
  double compassRotation = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initMapListener();
  }

  void initMapListener() async {
    await _mapController.onReady;

    _streamSubscription?.cancel();
    _streamSubscription = _mapController.mapEventStream.listen((event) {
      if (_mapController.center != centerPosition) {
        setState(() {
          centerButtonVisible = true;
        });
      }
      if (event is MapEventRotate) {
        setState(() {
          compassRotation = _mapController.rotation;
        });
      }
    });
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
        List<LatLng> points = [];
        List<Polygon> searchAreas = [];

        // Track
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

        // Mission Control
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

        // Search Areas
        if (state.searchAreaCollection != null) {
          state.searchAreaCollection.areas.forEach((area) {
            if (area.coordinates.length > 1) {
              // Area Search
              searchAreas.add(Polygon(
                  points: area.coordinates,
                  borderStrokeWidth: 2,
                  color: (area.color ?? Theme.of(context).accentColor)
                      .withOpacity(0.4),
                  borderColor: area.color ?? Theme.of(context).accentColor));
            } else if (area.coordinates.length == 1) {
              // Point Search
              _markers.add(Marker(
                anchorPos: AnchorPos.align(AnchorAlign.top),
                point: area.coordinates[0],
                builder: (ctx) => Container(
                  child: Icon(Icons.beenhere,
                      color: (area.color ?? Theme.of(context).accentColor)),
                ),
              ));
            }
          });
        }

        // Center Button and auto centering
        if (!initiallyCentered && state.missionState != null) {
          _mapController.move(centerPosition, _mapController.zoom);
          initiallyCentered = true;
          centerButtonVisible = false;
        }

        // Current position
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
              options: MapOptions(
                center: centerPosition,
                zoom: 14.0,
                maxZoom: 17.0,
              ),
              mapController: _mapController,
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: CachedNetworkTileProvider(),
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
                ),
                PolygonLayerOptions(polygons: searchAreas),
                MarkerLayerOptions(
                  markers: _markers,
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    child: Transform.rotate(
                      angle: (compassRotation % 360) * math.pi / 180,
                      child: FloatingActionButton(
                        onPressed: () {
                          _mapController.rotate(0);
                        },
                        child: const Icon(Icons.navigation, color: Colors.red),
                        backgroundColor: Color.fromARGB(180, 255, 255, 255),
                        mini: true,
                      ),
                    ),
                    visible: compassRotation != 0,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (_mapController.zoom != null) {
                          _mapController.move(
                              centerPosition, _mapController.zoom);
                          setState(() {
                            centerButtonVisible = false;
                          });
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Color.fromARGB(200, 255, 255, 255),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${S.of(context).MAP_DATA} © ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'opentopomap.org',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://opentopomap.org/credits');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
