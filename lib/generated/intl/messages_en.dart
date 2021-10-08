// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ABOUT": MessageLookupByLibrary.simpleMessage("About"),
        "ACCEPT_MISSION": MessageLookupByLibrary.simpleMessage("Confirm"),
        "ACCURACY": MessageLookupByLibrary.simpleMessage("Accuracy"),
        "ACTIVE_STATE":
            MessageLookupByLibrary.simpleMessage("Currently active:"),
        "ADMIN_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "The server-sided app configuration has not yet been completed by your organization. Please contact your administrator."),
        "ALTITUDE": MessageLookupByLibrary.simpleMessage("Altitude"),
        "APP_CONNECTION_HEADING":
            MessageLookupByLibrary.simpleMessage("Connect App:"),
        "APP_NAME": MessageLookupByLibrary.simpleMessage("eTrax|rescue"),
        "AUTHENTICATION_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "Access rights to the ressources on the server were revoked. Please log in again."),
        "BACK": MessageLookupByLibrary.simpleMessage("Go back"),
        "CACHE_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "An error occured while stored ressources were accessed."),
        "CANCEL": MessageLookupByLibrary.simpleMessage("Cancel"),
        "CENTER": MessageLookupByLibrary.simpleMessage("Center"),
        "CHANGE_STATUS": MessageLookupByLibrary.simpleMessage("Change status"),
        "CHECKING_PERMISSIONS": MessageLookupByLibrary.simpleMessage(
            "Checking location permission..."),
        "CHECKING_PERMISSIONS_DONE":
            MessageLookupByLibrary.simpleMessage("Location permission granted"),
        "CHECKING_SERVICES":
            MessageLookupByLibrary.simpleMessage("Checking services..."),
        "CHECKING_SERVICES_DONE": MessageLookupByLibrary.simpleMessage(
            "Location services successfully activated"),
        "CHECK_PERMISSIONS_TITLE":
            MessageLookupByLibrary.simpleMessage("Location permission check"),
        "CHECK_SERVICES_TITLE":
            MessageLookupByLibrary.simpleMessage("Location services check"),
        "CLEARING_STATE": MessageLookupByLibrary.simpleMessage(
            "App state is being cleared..."),
        "CLEARING_STATE_DONE":
            MessageLookupByLibrary.simpleMessage("Finalizing done"),
        "CLEAR_STATE_TITLE": MessageLookupByLibrary.simpleMessage("Finalize"),
        "CONFIRMATION_HEADING":
            MessageLookupByLibrary.simpleMessage("Confirmation"),
        "CONFIRM_CALL_TO_ACTION":
            MessageLookupByLibrary.simpleMessage("Confirm status update"),
        "CONFIRM_LEAVE_MISSION": MessageLookupByLibrary.simpleMessage(
            "Would you like to leave the mission?"),
        "CONFIRM_LOGOUT":
            MessageLookupByLibrary.simpleMessage("Would you like to log out?"),
        "CONNECT": MessageLookupByLibrary.simpleMessage("Connect"),
        "CONTINUE": MessageLookupByLibrary.simpleMessage("Continue"),
        "CONTINUE_ANYWAY":
            MessageLookupByLibrary.simpleMessage("Continue anyway"),
        "DATETIME": MessageLookupByLibrary.simpleMessage("Datetime"),
        "DROPDOWN_HINT":
            MessageLookupByLibrary.simpleMessage("-- Please Select --"),
        "ETRAX_LOCATION_NOTIFICATION": MessageLookupByLibrary.simpleMessage(
            "eTrax|rescue is currently collection location data for the active mission"),
        "EXERCISE": MessageLookupByLibrary.simpleMessage("Exercise"),
        "FIELD_REQUIRED": MessageLookupByLibrary.simpleMessage("required"),
        "FLASH_OFF": MessageLookupByLibrary.simpleMessage("Flash off"),
        "FLASH_ON": MessageLookupByLibrary.simpleMessage("Flash on"),
        "FUNCTION": MessageLookupByLibrary.simpleMessage("Function"),
        "GETTING_CURRENT_LOCATION": MessageLookupByLibrary.simpleMessage(
            "Acquiring current location..."),
        "GETTING_CURRENT_LOCATION_DONE":
            MessageLookupByLibrary.simpleMessage("Current location acquired"),
        "GET_LOCATION_TITLE":
            MessageLookupByLibrary.simpleMessage("Acquire Current Location"),
        "HEADING": MessageLookupByLibrary.simpleMessage("Heading"),
        "HEADING_GPS": MessageLookupByLibrary.simpleMessage("Location Details"),
        "HEADING_GPS_SHORT": MessageLookupByLibrary.simpleMessage("Location"),
        "HEADING_INFO": MessageLookupByLibrary.simpleMessage("Informationen"),
        "HEADING_INFO_SHORT": MessageLookupByLibrary.simpleMessage("Info"),
        "HEADING_MAP": MessageLookupByLibrary.simpleMessage("Map View"),
        "HEADING_MAP_SHORT": MessageLookupByLibrary.simpleMessage("Map"),
        "INVALID_INPUT_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "The provided URL does not resemble a valid format.\n Example for a valid URL: https://app.etrax.at"),
        "LAST_UPDATE": MessageLookupByLibrary.simpleMessage("Last Update"),
        "LATITUDE": MessageLookupByLibrary.simpleMessage("Latitude"),
        "LEAVE_MISSION": MessageLookupByLibrary.simpleMessage("Leave"),
        "LEGALESE": MessageLookupByLibrary.simpleMessage(
            "The official eTrax|rescue app"),
        "LOCATION_DISCLAIMER": MessageLookupByLibrary.simpleMessage(
            "In this state the app collects location data to enable mission control to monitor your location during the mission even when the app is closed or not in use."),
        "LOCATION_PERMISSION_DENIED_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage("Location permission denied"),
        "LOCATION_PERMISSION_PERMANENTLY_DENIED_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage(
                "Location permission permanently denied. Open settings to resolve this."),
        "LOCATION_SERVICES_DISABLED_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage(
                "Location services are disabled"),
        "LOCATION_UPDATES_ACTIVE":
            MessageLookupByLibrary.simpleMessage("Location updates active"),
        "LOGGING_OUT": MessageLookupByLibrary.simpleMessage("Logging out..."),
        "LOGGING_OUT_DONE": MessageLookupByLibrary.simpleMessage("Logged out"),
        "LOGIN": MessageLookupByLibrary.simpleMessage("Login"),
        "LOGIN_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "Invalid username, password or organization"),
        "LOGIN_HEADING": MessageLookupByLibrary.simpleMessage("Login"),
        "LOGOUT": MessageLookupByLibrary.simpleMessage("Logout"),
        "LOGOUT_TITLE": MessageLookupByLibrary.simpleMessage("Logout"),
        "LONGITUDE": MessageLookupByLibrary.simpleMessage("Longitude"),
        "MAP_DATA": MessageLookupByLibrary.simpleMessage("Map data"),
        "MISSION": MessageLookupByLibrary.simpleMessage("Mission"),
        "MISSIONS_AND_EXERCICES":
            MessageLookupByLibrary.simpleMessage("Missions and Exercises"),
        "MISSION_LOCATION": MessageLookupByLibrary.simpleMessage("Location"),
        "MISSION_NAME": MessageLookupByLibrary.simpleMessage("Mission Name"),
        "MISSION_START": MessageLookupByLibrary.simpleMessage("Begin"),
        "NETWORK_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage("Your device is offline."),
        "NO_DETAILS": MessageLookupByLibrary.simpleMessage(
            "There are currently no mission details available."),
        "NO_LOCK_ON_LOCATION_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage(
                "Couldn\'t acquire current location"),
        "NO_MISSIONS": MessageLookupByLibrary.simpleMessage(
            "There are no active missions."),
        "OK": MessageLookupByLibrary.simpleMessage("Ok"),
        "OPEN_LOCATION_SETTINGS": MessageLookupByLibrary.simpleMessage("Open"),
        "ORGANIZATION": MessageLookupByLibrary.simpleMessage("Organization"),
        "ORGANIZATION_TRACKING": MessageLookupByLibrary.simpleMessage(
            "Your organisation enabled location tracking for the following states:"),
        "PASSWORD": MessageLookupByLibrary.simpleMessage("Password"),
        "PLATFORM_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage("A plugin raised an error"),
        "POI_DESCRIPTION":
            MessageLookupByLibrary.simpleMessage("POI Description"),
        "PRIVACY_NOTICE":
            MessageLookupByLibrary.simpleMessage("Privacy Notice"),
        "QUICK_ACTION_TITLE":
            MessageLookupByLibrary.simpleMessage("Trigger QuickAction"),
        "RECONNECT": MessageLookupByLibrary.simpleMessage("Reconnect App"),
        "RESOLVE": MessageLookupByLibrary.simpleMessage("Resolve"),
        "RETRIEVE_SETTINGS_TITLE":
            MessageLookupByLibrary.simpleMessage("Load app settings"),
        "RETRIEVING_SETTINGS":
            MessageLookupByLibrary.simpleMessage("Loading app settings..."),
        "RETRIEVING_SETTINGS_DONE":
            MessageLookupByLibrary.simpleMessage("App settings loaded."),
        "RETRY": MessageLookupByLibrary.simpleMessage("Retry"),
        "SELECT_STATE":
            MessageLookupByLibrary.simpleMessage("Select new state:"),
        "SENT": MessageLookupByLibrary.simpleMessage("Sent"),
        "SERVER_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "The server is not reachable at the moment."),
        "SERVER_URL_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "Either the provided URI doesn\'t point to a valid eTrax|rescue Server,\n or the server is not reachable at the moment."),
        "SETTINGS": MessageLookupByLibrary.simpleMessage("Settings"),
        "SHOW_ON_MAP": MessageLookupByLibrary.simpleMessage("Show on map"),
        "SPEED": MessageLookupByLibrary.simpleMessage("Speed"),
        "SPEED_ACCURACY":
            MessageLookupByLibrary.simpleMessage("Speed accuracy"),
        "STARTING_UPDATES": MessageLookupByLibrary.simpleMessage(
            "Starting location updates..."),
        "STARTING_UPDATES_DONE": MessageLookupByLibrary.simpleMessage(
            "Location updates started successfully"),
        "START_UPDATES_TITLE":
            MessageLookupByLibrary.simpleMessage("Start location updates"),
        "STATE": MessageLookupByLibrary.simpleMessage("State"),
        "STATE_HEADING": MessageLookupByLibrary.simpleMessage("Update State"),
        "STATUS_DISPLAY": MessageLookupByLibrary.simpleMessage("State: "),
        "STATUS_NO_LOCATION": MessageLookupByLibrary.simpleMessage(
            "The current state does not access this device\'s location."),
        "STOPPING_UPDATES": MessageLookupByLibrary.simpleMessage(
            "Stopping location updates..."),
        "STOPPING_UPDATES_DONE": MessageLookupByLibrary.simpleMessage(
            "Location updates stopped successfully"),
        "STOP_UPDATES_TITLE":
            MessageLookupByLibrary.simpleMessage("Stop location updates"),
        "SUBMIT_POI": MessageLookupByLibrary.simpleMessage("Submit POI"),
        "TAKE_PHOTO": MessageLookupByLibrary.simpleMessage("Take a photo"),
        "TOKEN_EXPIRED_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "Access rights to the ressources on the server expired. Please log in again."),
        "TOO_MANY_TRYS_FAILURE_MESSAGE": MessageLookupByLibrary.simpleMessage(
            "Maximum number of retry attempts exceeded. Try again in a minute."),
        "TRACKING_INFO":
            MessageLookupByLibrary.simpleMessage("Tracking Information"),
        "TRIGGERING_QUICK_ACTION":
            MessageLookupByLibrary.simpleMessage("Sending QuickAction..."),
        "TRIGGERING_QUICK_ACTION_DONE":
            MessageLookupByLibrary.simpleMessage("QuickAction sent"),
        "UNEXPECTED_FAILURE_MESSAGE":
            MessageLookupByLibrary.simpleMessage("A unexpected error occured."),
        "UPDATE_STATE_TITLE":
            MessageLookupByLibrary.simpleMessage("Status update"),
        "UPDATING_STATE":
            MessageLookupByLibrary.simpleMessage("Updating status..."),
        "UPDATING_STATE_DONE":
            MessageLookupByLibrary.simpleMessage("Status updated"),
        "USERNAME": MessageLookupByLibrary.simpleMessage("Username"),
        "YES": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
