import 'package:background_location/background_location.dart';

import '../bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        LatLng centerPosition;
        List<LatLng> points;
        if (state.locationHistory.length > 0) {
          centerPosition = LatLng(state.locationHistory[0].latitude,
              state.locationHistory[0].longitude);
          points = state.locationHistory
              .map((locationData) =>
                  LatLng(locationData.latitude, locationData.longitude))
              .toList();
        } else {
          centerPosition = LatLng(48.2084114, 16.3712767);
          points = [centerPosition];
        }
        if (_mapController.ready) {
          if (_mapController.zoom != null) {
            _mapController.move(centerPosition, _mapController.zoom);
          }
        }

        return FlutterMap(
          key: _key,
          options: MapOptions(
            center: centerPosition,
            zoom: 12.0,
          ),
          mapController: _mapController,
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              tileProvider: CachedNetworkTileProvider(),
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: centerPosition,
                  builder: (ctx) => Container(
                    child: Icon(Icons.my_location),
                  ),
                ),
              ],
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
        );
      },
    );
  }
}
