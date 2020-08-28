// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "ACCEPT_MISSION" : MessageLookupByLibrary.simpleMessage("Zusagen"),
    "ACCURACY" : MessageLookupByLibrary.simpleMessage("Genauigkeit"),
    "ACTIVE_STATE" : MessageLookupByLibrary.simpleMessage("Derzeit aktiver Status"),
    "ALTITUDE" : MessageLookupByLibrary.simpleMessage("Altitude"),
    "APP_CONNECTION_HEADING" : MessageLookupByLibrary.simpleMessage("App verbinden:"),
    "APP_NAME" : MessageLookupByLibrary.simpleMessage("eTrax|rescue"),
    "AUTHENTICATION_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Die Zugriffsrechte auf die Ressourcen am Server sind abgelaufen. Bitte erneut anmelden."),
    "AUTHENTICATION_SUCCESS" : MessageLookupByLibrary.simpleMessage("Erfolg!"),
    "BACK" : MessageLookupByLibrary.simpleMessage("Zurück"),
    "CACHE_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Beim Speichern des Links ist ein Fehler aufgetreten."),
    "CHANGE_STATUS" : MessageLookupByLibrary.simpleMessage("Status ändern"),
    "CHECKING_PERMISSIONS" : MessageLookupByLibrary.simpleMessage("Berechtigungen werden überprüft..."),
    "CHECKING_PERMISSIONS_DONE" : MessageLookupByLibrary.simpleMessage("Standortberechtigung gewährt"),
    "CHECKING_SERVICES" : MessageLookupByLibrary.simpleMessage("Ortungsdienste werden überprüft..."),
    "CHECKING_SERVICES_DONE" : MessageLookupByLibrary.simpleMessage("Ortungsdienste erforlgreich aktiviert"),
    "CHECKING_SERVICES_ERROR" : MessageLookupByLibrary.simpleMessage("Fehler beim Anfordern von Ortungsdiensten"),
    "CONFIRMATION_HEADING" : MessageLookupByLibrary.simpleMessage("Rückmelden"),
    "CONNECT" : MessageLookupByLibrary.simpleMessage("Verbinden"),
    "CONTINUE" : MessageLookupByLibrary.simpleMessage("Weiter"),
    "DATETIME" : MessageLookupByLibrary.simpleMessage("Zeitpunkt"),
    "DROPDOWN_HINT" : MessageLookupByLibrary.simpleMessage("-- Bitte Auswählen --"),
    "ETRAX_LOCATION_NOTIFICATION" : MessageLookupByLibrary.simpleMessage("eTrax|rescue sammelt gerade für den aktiven Einsatz Standortdaten"),
    "FIELD_REQUIRED" : MessageLookupByLibrary.simpleMessage("Pflichtfeld"),
    "FUNCTION" : MessageLookupByLibrary.simpleMessage("Funktion"),
    "HEADING" : MessageLookupByLibrary.simpleMessage("Richtung"),
    "HEADING_GPS" : MessageLookupByLibrary.simpleMessage("GPS Details"),
    "HEADING_GPS_SHORT" : MessageLookupByLibrary.simpleMessage("GPS"),
    "HEADING_INFO" : MessageLookupByLibrary.simpleMessage("Informationen"),
    "HEADING_INFO_SHORT" : MessageLookupByLibrary.simpleMessage("Info"),
    "HEADING_MAP" : MessageLookupByLibrary.simpleMessage("Kartenansicht"),
    "HEADING_MAP_SHORT" : MessageLookupByLibrary.simpleMessage("Karte"),
    "INVALID_INPUT_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der eingegebene URL entspricht nicht dem erwarteten Format.\n Beispiel für das richtige Format: https://etrax.at"),
    "LATITUDE" : MessageLookupByLibrary.simpleMessage("Latitude"),
    "LEAVE_MISSION" : MessageLookupByLibrary.simpleMessage("Einsatz verlassen"),
    "LOCATION_PERMISSION_DENIED" : MessageLookupByLibrary.simpleMessage("Standortberechtigung verweigert"),
    "LOCATION_PERMISSION_DENIED_FOREVER" : MessageLookupByLibrary.simpleMessage("Standortberechtigung permanent verweigert. Öffne die Standorteinstellungen um dies zu beheben."),
    "LOCATION_UPDATES_ACTIVE" : MessageLookupByLibrary.simpleMessage("Standortdienst aktiv"),
    "LOGIN" : MessageLookupByLibrary.simpleMessage("Anmelden"),
    "LOGIN_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der eingegebene Username oder das Passwort ist falsch"),
    "LOGIN_HEADING" : MessageLookupByLibrary.simpleMessage("Anmelden"),
    "LOGOUT" : MessageLookupByLibrary.simpleMessage("Abmelden"),
    "LONGITUDE" : MessageLookupByLibrary.simpleMessage("Longitude"),
    "MISSION" : MessageLookupByLibrary.simpleMessage("Einsatz"),
    "MISSIONS" : MessageLookupByLibrary.simpleMessage("Einsätze"),
    "MISSION_LOCATION" : MessageLookupByLibrary.simpleMessage("Einsatzort"),
    "MISSION_NAME" : MessageLookupByLibrary.simpleMessage("Einsatzbezeichnung"),
    "MISSION_START" : MessageLookupByLibrary.simpleMessage("Alarmierungsdatum"),
    "NETWORK_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Ihr Gerät ist offline."),
    "OK" : MessageLookupByLibrary.simpleMessage("Ok"),
    "OPEN_LOCATION_SETTINGS" : MessageLookupByLibrary.simpleMessage("Öffnen"),
    "ORGANIZATION" : MessageLookupByLibrary.simpleMessage("Organisation"),
    "PASSWORD" : MessageLookupByLibrary.simpleMessage("Passwort"),
    "POI_DESCRIPTION" : MessageLookupByLibrary.simpleMessage("POI Beschreibung"),
    "RECONNECT" : MessageLookupByLibrary.simpleMessage("App neu verbinden"),
    "RESOLVE" : MessageLookupByLibrary.simpleMessage("Beheben"),
    "RETRIEVING_SETTINGS" : MessageLookupByLibrary.simpleMessage("Einstellungen werden geladen..."),
    "RETRIEVING_SETTINGS_DONE" : MessageLookupByLibrary.simpleMessage("Einstellungen geladen"),
    "RETRIEVING_SETTINGS_ERROR" : MessageLookupByLibrary.simpleMessage("Fehler beim Laden der Einstellungen"),
    "RETRY" : MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
    "SAME_STATE" : MessageLookupByLibrary.simpleMessage("Der selbe Status kann nicht doppelt gemeldet werden"),
    "SERVER_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der Server ist derzeit nicht erreichbar."),
    "SERVER_URL_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der angegebene URL zeigt zu keinem eTrax|rescue Server, bzw. dieser ist derzeit nicht erreichbar."),
    "SERVICES_DISABLED" : MessageLookupByLibrary.simpleMessage("Ortungsdienste sind deaktiviert"),
    "SETTINGS" : MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "SHOW_ON_MAP" : MessageLookupByLibrary.simpleMessage("Auf Karte anzeigen"),
    "SPEED" : MessageLookupByLibrary.simpleMessage("Geschwindigkeit"),
    "SPEED_ACCURACY" : MessageLookupByLibrary.simpleMessage("Geschwindigkeits-Genauigkeit"),
    "STARTING_UPDATES" : MessageLookupByLibrary.simpleMessage("Standortdienst wird gestartet..."),
    "STARTING_UPDATES_DONE" : MessageLookupByLibrary.simpleMessage("Standortdienst erfolgreich gestartet"),
    "STATE" : MessageLookupByLibrary.simpleMessage("Status"),
    "STATE_HEADING" : MessageLookupByLibrary.simpleMessage("Status Aktualisieren"),
    "STATUS_DISPLAY" : MessageLookupByLibrary.simpleMessage("Status: "),
    "STOPPING_UPDATES" : MessageLookupByLibrary.simpleMessage("Standortdienst wird gestoppt..."),
    "STOPPING_UPDATES_DONE" : MessageLookupByLibrary.simpleMessage("Standortdienst erfolgreich gestoppt"),
    "SUBMIT_POI" : MessageLookupByLibrary.simpleMessage("POI Hochladen"),
    "TAKE_PHOTO" : MessageLookupByLibrary.simpleMessage("Foto aufnehmen"),
    "UNEXPECTED_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Ein unerwarteter Fehler ist aufgetreten."),
    "UPDATE_STATE" : MessageLookupByLibrary.simpleMessage("Aktualisieren"),
    "UPDATING_STATE" : MessageLookupByLibrary.simpleMessage("Status wird aktualisiert..."),
    "UPDATING_STATE_DONE" : MessageLookupByLibrary.simpleMessage("Status wurde aktualisiert"),
    "USERNAME" : MessageLookupByLibrary.simpleMessage("Benutzername")
  };
}
