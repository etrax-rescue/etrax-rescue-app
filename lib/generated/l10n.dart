// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `eTrax|rescue`
  String get APP_NAME {
    return Intl.message(
      'eTrax|rescue',
      name: 'APP_NAME',
      desc: '',
      args: [],
    );
  }

  /// `required`
  String get FIELD_REQUIRED {
    return Intl.message(
      'required',
      name: 'FIELD_REQUIRED',
      desc: '',
      args: [],
    );
  }

  /// `Go back`
  String get BACK {
    return Intl.message(
      'Go back',
      name: 'BACK',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get RETRY {
    return Intl.message(
      'Retry',
      name: 'RETRY',
      desc: '',
      args: [],
    );
  }

  /// `-- Please Select --`
  String get DROPDOWN_HINT {
    return Intl.message(
      '-- Please Select --',
      name: 'DROPDOWN_HINT',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get OK {
    return Intl.message(
      'Ok',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get CONTINUE {
    return Intl.message(
      'Continue',
      name: 'CONTINUE',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get ABOUT {
    return Intl.message(
      'About',
      name: 'ABOUT',
      desc: '',
      args: [],
    );
  }

  /// `Connect App:`
  String get APP_CONNECTION_HEADING {
    return Intl.message(
      'Connect App:',
      name: 'APP_CONNECTION_HEADING',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get CONNECT {
    return Intl.message(
      'Connect',
      name: 'CONNECT',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get LOGIN_HEADING {
    return Intl.message(
      'Login',
      name: 'LOGIN_HEADING',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get LOGIN {
    return Intl.message(
      'Login',
      name: 'LOGIN',
      desc: '',
      args: [],
    );
  }

  /// `Organization`
  String get ORGANIZATION {
    return Intl.message(
      'Organization',
      name: 'ORGANIZATION',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get USERNAME {
    return Intl.message(
      'Username',
      name: 'USERNAME',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get PASSWORD {
    return Intl.message(
      'Password',
      name: 'PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get AUTHENTICATION_SUCCESS {
    return Intl.message(
      'Success!',
      name: 'AUTHENTICATION_SUCCESS',
      desc: '',
      args: [],
    );
  }

  /// `Missions`
  String get MISSIONS {
    return Intl.message(
      'Missions',
      name: 'MISSIONS',
      desc: '',
      args: [],
    );
  }

  /// `Mission`
  String get MISSION {
    return Intl.message(
      'Mission',
      name: 'MISSION',
      desc: '',
      args: [],
    );
  }

  /// `Mission Name`
  String get MISSION_NAME {
    return Intl.message(
      'Mission Name',
      name: 'MISSION_NAME',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get LOGOUT {
    return Intl.message(
      'Logout',
      name: 'LOGOUT',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect App`
  String get RECONNECT {
    return Intl.message(
      'Reconnect App',
      name: 'RECONNECT',
      desc: '',
      args: [],
    );
  }

  /// `There are no active missions.`
  String get NO_MISSIONS {
    return Intl.message(
      'There are no active missions.',
      name: 'NO_MISSIONS',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get CONFIRMATION_HEADING {
    return Intl.message(
      'Confirmation',
      name: 'CONFIRMATION_HEADING',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get ACCEPT_MISSION {
    return Intl.message(
      'Confirm',
      name: 'ACCEPT_MISSION',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get LATITUDE {
    return Intl.message(
      'Latitude',
      name: 'LATITUDE',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get LONGITUDE {
    return Intl.message(
      'Longitude',
      name: 'LONGITUDE',
      desc: '',
      args: [],
    );
  }

  /// `Show on map`
  String get SHOW_ON_MAP {
    return Intl.message(
      'Show on map',
      name: 'SHOW_ON_MAP',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get MISSION_LOCATION {
    return Intl.message(
      'Location',
      name: 'MISSION_LOCATION',
      desc: '',
      args: [],
    );
  }

  /// `Begin`
  String get MISSION_START {
    return Intl.message(
      'Begin',
      name: 'MISSION_START',
      desc: '',
      args: [],
    );
  }

  /// `Function`
  String get FUNCTION {
    return Intl.message(
      'Function',
      name: 'FUNCTION',
      desc: '',
      args: [],
    );
  }

  /// `Update State`
  String get STATE_HEADING {
    return Intl.message(
      'Update State',
      name: 'STATE_HEADING',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get STATE {
    return Intl.message(
      'State',
      name: 'STATE',
      desc: '',
      args: [],
    );
  }

  /// `Currently active state`
  String get ACTIVE_STATE {
    return Intl.message(
      'Currently active state',
      name: 'ACTIVE_STATE',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get UPDATE_STATE {
    return Intl.message(
      'Update',
      name: 'UPDATE_STATE',
      desc: '',
      args: [],
    );
  }

  /// `Loading app settings...`
  String get RETRIEVING_SETTINGS {
    return Intl.message(
      'Loading app settings...',
      name: 'RETRIEVING_SETTINGS',
      desc: '',
      args: [],
    );
  }

  /// `App settings loaded.`
  String get RETRIEVING_SETTINGS_DONE {
    return Intl.message(
      'App settings loaded.',
      name: 'RETRIEVING_SETTINGS_DONE',
      desc: '',
      args: [],
    );
  }

  /// `Error while loading app settings`
  String get RETRIEVING_SETTINGS_ERROR {
    return Intl.message(
      'Error while loading app settings',
      name: 'RETRIEVING_SETTINGS_ERROR',
      desc: '',
      args: [],
    );
  }

  /// `Checking location permission...`
  String get CHECKING_PERMISSIONS {
    return Intl.message(
      'Checking location permission...',
      name: 'CHECKING_PERMISSIONS',
      desc: '',
      args: [],
    );
  }

  /// `Location permission granted`
  String get CHECKING_PERMISSIONS_DONE {
    return Intl.message(
      'Location permission granted',
      name: 'CHECKING_PERMISSIONS_DONE',
      desc: '',
      args: [],
    );
  }

  /// `Location permission denied`
  String get LOCATION_PERMISSION_DENIED {
    return Intl.message(
      'Location permission denied',
      name: 'LOCATION_PERMISSION_DENIED',
      desc: '',
      args: [],
    );
  }

  /// `Location permission permanently denied. Open settings to resolve this.`
  String get LOCATION_PERMISSION_DENIED_FOREVER {
    return Intl.message(
      'Location permission permanently denied. Open settings to resolve this.',
      name: 'LOCATION_PERMISSION_DENIED_FOREVER',
      desc: '',
      args: [],
    );
  }

  /// `Checking services...`
  String get CHECKING_SERVICES {
    return Intl.message(
      'Checking services...',
      name: 'CHECKING_SERVICES',
      desc: '',
      args: [],
    );
  }

  /// `Location services successfully activated`
  String get CHECKING_SERVICES_DONE {
    return Intl.message(
      'Location services successfully activated',
      name: 'CHECKING_SERVICES_DONE',
      desc: '',
      args: [],
    );
  }

  /// `Error while activating location services`
  String get CHECKING_SERVICES_ERROR {
    return Intl.message(
      'Error while activating location services',
      name: 'CHECKING_SERVICES_ERROR',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled`
  String get SERVICES_DISABLED {
    return Intl.message(
      'Location services are disabled',
      name: 'SERVICES_DISABLED',
      desc: '',
      args: [],
    );
  }

  /// `Updating status...`
  String get UPDATING_STATE {
    return Intl.message(
      'Updating status...',
      name: 'UPDATING_STATE',
      desc: '',
      args: [],
    );
  }

  /// `Status updated`
  String get UPDATING_STATE_DONE {
    return Intl.message(
      'Status updated',
      name: 'UPDATING_STATE_DONE',
      desc: '',
      args: [],
    );
  }

  /// `Starting location updates...`
  String get STARTING_UPDATES {
    return Intl.message(
      'Starting location updates...',
      name: 'STARTING_UPDATES',
      desc: '',
      args: [],
    );
  }

  /// `Location updates started successfully`
  String get STARTING_UPDATES_DONE {
    return Intl.message(
      'Location updates started successfully',
      name: 'STARTING_UPDATES_DONE',
      desc: '',
      args: [],
    );
  }

  /// `Stopping location updates...`
  String get STOPPING_UPDATES {
    return Intl.message(
      'Stopping location updates...',
      name: 'STOPPING_UPDATES',
      desc: '',
      args: [],
    );
  }

  /// `Location updates stopped successfully`
  String get STOPPING_UPDATES_DONE {
    return Intl.message(
      'Location updates stopped successfully',
      name: 'STOPPING_UPDATES_DONE',
      desc: '',
      args: [],
    );
  }

  /// `Resolve`
  String get RESOLVE {
    return Intl.message(
      'Resolve',
      name: 'RESOLVE',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get OPEN_LOCATION_SETTINGS {
    return Intl.message(
      'Open',
      name: 'OPEN_LOCATION_SETTINGS',
      desc: '',
      args: [],
    );
  }

  /// `Location updates active`
  String get LOCATION_UPDATES_ACTIVE {
    return Intl.message(
      'Location updates active',
      name: 'LOCATION_UPDATES_ACTIVE',
      desc: '',
      args: [],
    );
  }

  /// `eTrax|rescue is currently collection location data for the active mission`
  String get ETRAX_LOCATION_NOTIFICATION {
    return Intl.message(
      'eTrax|rescue is currently collection location data for the active mission',
      name: 'ETRAX_LOCATION_NOTIFICATION',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get SETTINGS {
    return Intl.message(
      'Settings',
      name: 'SETTINGS',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get TAKE_PHOTO {
    return Intl.message(
      'Take a photo',
      name: 'TAKE_PHOTO',
      desc: '',
      args: [],
    );
  }

  /// `Change status`
  String get CHANGE_STATUS {
    return Intl.message(
      'Change status',
      name: 'CHANGE_STATUS',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get LEAVE_MISSION {
    return Intl.message(
      'Leave',
      name: 'LEAVE_MISSION',
      desc: '',
      args: [],
    );
  }

  /// `Informationen`
  String get HEADING_INFO {
    return Intl.message(
      'Informationen',
      name: 'HEADING_INFO',
      desc: '',
      args: [],
    );
  }

  /// `GPS Details`
  String get HEADING_GPS {
    return Intl.message(
      'GPS Details',
      name: 'HEADING_GPS',
      desc: '',
      args: [],
    );
  }

  /// `Map View`
  String get HEADING_MAP {
    return Intl.message(
      'Map View',
      name: 'HEADING_MAP',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get HEADING_INFO_SHORT {
    return Intl.message(
      'Info',
      name: 'HEADING_INFO_SHORT',
      desc: '',
      args: [],
    );
  }

  /// `GPS`
  String get HEADING_GPS_SHORT {
    return Intl.message(
      'GPS',
      name: 'HEADING_GPS_SHORT',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get HEADING_MAP_SHORT {
    return Intl.message(
      'Map',
      name: 'HEADING_MAP_SHORT',
      desc: '',
      args: [],
    );
  }

  /// `State: `
  String get STATUS_DISPLAY {
    return Intl.message(
      'State: ',
      name: 'STATUS_DISPLAY',
      desc: '',
      args: [],
    );
  }

  /// `The current state does not access this device's location.`
  String get STATUS_NO_LOCATION {
    return Intl.message(
      'The current state does not access this device\'s location.',
      name: 'STATUS_NO_LOCATION',
      desc: '',
      args: [],
    );
  }

  /// `There are currently no mission details available.`
  String get NO_DETAILS {
    return Intl.message(
      'There are currently no mission details available.',
      name: 'NO_DETAILS',
      desc: '',
      args: [],
    );
  }

  /// `Submit POI`
  String get SUBMIT_POI {
    return Intl.message(
      'Submit POI',
      name: 'SUBMIT_POI',
      desc: '',
      args: [],
    );
  }

  /// `POI Description`
  String get POI_DESCRIPTION {
    return Intl.message(
      'POI Description',
      name: 'POI_DESCRIPTION',
      desc: '',
      args: [],
    );
  }

  /// `Center`
  String get CENTER {
    return Intl.message(
      'Center',
      name: 'CENTER',
      desc: '',
      args: [],
    );
  }

  /// `Datetime`
  String get DATETIME {
    return Intl.message(
      'Datetime',
      name: 'DATETIME',
      desc: '',
      args: [],
    );
  }

  /// `Altitude`
  String get ALTITUDE {
    return Intl.message(
      'Altitude',
      name: 'ALTITUDE',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy`
  String get ACCURACY {
    return Intl.message(
      'Accuracy',
      name: 'ACCURACY',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get SPEED {
    return Intl.message(
      'Speed',
      name: 'SPEED',
      desc: '',
      args: [],
    );
  }

  /// `Speed accuracy`
  String get SPEED_ACCURACY {
    return Intl.message(
      'Speed accuracy',
      name: 'SPEED_ACCURACY',
      desc: '',
      args: [],
    );
  }

  /// `Heading`
  String get HEADING {
    return Intl.message(
      'Heading',
      name: 'HEADING',
      desc: '',
      args: [],
    );
  }

  /// `A unexpected error occured.`
  String get UNEXPECTED_FAILURE_MESSAGE {
    return Intl.message(
      'A unexpected error occured.',
      name: 'UNEXPECTED_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `Your device is offline.`
  String get NETWORK_FAILURE_MESSAGE {
    return Intl.message(
      'Your device is offline.',
      name: 'NETWORK_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `Either the provided URI doesn't point to a valid eTrax|rescue Server,\n or the server is not reachable at the moment.`
  String get SERVER_URL_FAILURE_MESSAGE {
    return Intl.message(
      'Either the provided URI doesn\'t point to a valid eTrax|rescue Server,\n or the server is not reachable at the moment.',
      name: 'SERVER_URL_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `The server is not reachable at the moment.`
  String get SERVER_FAILURE_MESSAGE {
    return Intl.message(
      'The server is not reachable at the moment.',
      name: 'SERVER_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `An error occured during the URI storage process.`
  String get CACHE_FAILURE_MESSAGE {
    return Intl.message(
      'An error occured during the URI storage process.',
      name: 'CACHE_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `The provided URL does not resemble a valid format.\n Example for a valid URL: https://etrax.at`
  String get INVALID_INPUT_FAILURE_MESSAGE {
    return Intl.message(
      'The provided URL does not resemble a valid format.\n Example for a valid URL: https://etrax.at',
      name: 'INVALID_INPUT_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `Invalid username or password`
  String get LOGIN_FAILURE_MESSAGE {
    return Intl.message(
      'Invalid username or password',
      name: 'LOGIN_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }

  /// `Access rights to the ressources on the server expired. Please log in again.`
  String get AUTHENTICATION_FAILURE_MESSAGE {
    return Intl.message(
      'Access rights to the ressources on the server expired. Please log in again.',
      name: 'AUTHENTICATION_FAILURE_MESSAGE',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}