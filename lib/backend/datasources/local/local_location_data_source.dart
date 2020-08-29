import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';

abstract class LocalLocationDataSource {
  Future<bool> serviceEnabled(
      LocationAccuracy accuracy, int interval, double distanceFilter);

  Future<bool> requestService(
      LocationAccuracy accuracy, int interval, double distanceFilter);

  Future<PermissionStatus> hasPermission();

  Future<PermissionStatus> requestPermission();

  Future<bool> updatesActive();

  Future<bool> startUpdates(
    LocationAccuracy accuracy,
    int interval,
    double distanceFilter,
    String notificationTitle,
    String notificationBody,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    String label,
  );

  Future<bool> stopUpdates();

  Stream<LocationData> getLocationUpdateStream(String label);
}

class LocalLocationDataSourceImpl implements LocalLocationDataSource {
  final BackgroundLocation backgroundLocation;
  LocalLocationDataSourceImpl(this.backgroundLocation);

  @override
  Stream<LocationData> getLocationUpdateStream(String label) {
    return backgroundLocation.getLocationUpdateStream(label);
  }

  @override
  Future<PermissionStatus> hasPermission() async {
    return await backgroundLocation.hasPermission();
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    return await backgroundLocation.requestPermission();
  }

  @override
  Future<bool> requestService(
      LocationAccuracy accuracy, int interval, double distanceFilter) async {
    return await backgroundLocation.requestService(
        accuracy: accuracy, interval: interval, distanceFilter: distanceFilter);
  }

  @override
  Future<bool> serviceEnabled(
      LocationAccuracy accuracy, int interval, double distanceFilter) async {
    return await backgroundLocation.serviceEnabled(
        accuracy: accuracy, interval: interval, distanceFilter: distanceFilter);
  }

  @override
  Future<bool> startUpdates(
      LocationAccuracy accuracy,
      int interval,
      double distanceFilter,
      String notificationTitle,
      String notificationBody,
      AppConnection appConnection,
      AuthenticationData authenticationData,
      String label) async {
    return await backgroundLocation.startUpdates(
      accuracy: accuracy,
      interval: interval,
      distanceFilter: distanceFilter,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      url: appConnection
          .generateUri(subPath: EtraxServerEndpoints.postLocation)
          .toString(),
      header: authenticationData.generateAuthHeader(),
      label: label,
    );
  }

  @override
  Future<bool> stopUpdates() async {
    return await backgroundLocation.stopUpdates();
  }

  @override
  Future<bool> updatesActive() async {
    return await backgroundLocation.updatesActive();
  }
}