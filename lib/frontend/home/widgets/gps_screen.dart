import 'package:background_location/background_location.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

class GPSScreen extends StatelessWidget {
  GPSScreen({@required this.locationActive}) : super();

  final bool locationActive;

  @override
  Widget build(BuildContext context) {
    if (locationActive) {
      return Container(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.locationHistory.length > 0) {
              return SingleChildScrollView(
                  child: LocationDataWidget(
                      locationData: state.locationHistory[0]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
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
}

class LocationDataWidget extends StatelessWidget {
  const LocationDataWidget({this.locationData});
  final LocationData locationData;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt());
    return Container(
      child: Column(children: <Widget>[
        DataEntry(label: 'Datetime', data: '$dateTime'),
        DataEntry(label: 'Latitude', data: '${locationData.latitude}'),
        DataEntry(label: 'Longitude', data: '${locationData.longitude}'),
        DataEntry(label: 'Accuracy', data: '${locationData.accuracy}'),
        DataEntry(label: 'Altitude', data: '${locationData.altitude}'),
        DataEntry(label: 'Speed', data: '${locationData.speed}'),
        DataEntry(
            label: 'Speed Accuracy', data: '${locationData.speedAccuracy}'),
        DataEntry(label: 'Heading', data: '${locationData.heading}'),
      ]),
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
