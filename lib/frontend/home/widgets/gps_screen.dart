import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../bloc/home_bloc.dart';

class GPSScreen extends StatelessWidget {
  GPSScreen() : super();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.missionState != null) {
          if (state.missionState.state.locationAccuracy != 0) {
            if (state.locationHistory.length > 0) {
              return Container(
                child: SingleChildScrollView(
                  child: LocationDataWidget(
                      locationData: state.locationHistory.last),
                ),
              );
            }
          } else {
            return Container(
              alignment: Alignment.center,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 72,
                        color: Colors.grey,
                      ),
                      Text(
                        S.of(context).STATUS_NO_LOCATION,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class LocationDataWidget extends StatelessWidget {
  const LocationDataWidget({this.locationData});
  final LocationData locationData;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt());
    List<Widget> children = [
      DataEntry(label: S.of(context).LAST_UPDATE, data: '$dateTime'),
      DataEntry(
          label: S.of(context).LATITUDE, data: '${locationData.latitude}'),
      DataEntry(
          label: S.of(context).LONGITUDE, data: '${locationData.longitude}'),
      DataEntry(
          label: S.of(context).ACCURACY, data: '${locationData.accuracy}'),
      DataEntry(
          label: S.of(context).ALTITUDE, data: '${locationData.altitude}'),
    ];

    if (locationData.speed >= 0.0) {
      children.add(
          DataEntry(label: S.of(context).SPEED, data: '${locationData.speed}'));
    }
    if (locationData.speedAccuracy >= 0.0) {
      children.add(DataEntry(
          label: S.of(context).SPEED_ACCURACY,
          data: '${locationData.speedAccuracy}'));
    }
    if (locationData.heading >= 0.0) {
      children.add(DataEntry(
          label: S.of(context).HEADING, data: '${locationData.heading}'));
    }
    return Container(
      child: Column(
        children: children,
      ),
    );
  }
}

class DataEntry extends StatelessWidget {
  const DataEntry({this.label, this.data});
  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(data, style: TextStyle(color: Colors.grey))
          ]),
    );
  }
}
