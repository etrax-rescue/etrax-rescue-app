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
    "APP_CONNECT_HEADING" : MessageLookupByLibrary.simpleMessage("App verbinden:"),
    "AUTHENTICATION_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Die Zugriffsrechte auf die Ressourcen am Server sind abgelaufen. Bitte erneut anmelden."),
    "AUTHENTICATION_SUCCESS" : MessageLookupByLibrary.simpleMessage("Erfolg!"),
    "CACHE_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Beim Speichern des Links ist ein Fehler aufgetreten."),
    "CONNECT" : MessageLookupByLibrary.simpleMessage("Verbinden"),
    "FIELD_REQUIRED" : MessageLookupByLibrary.simpleMessage("Bitte dieses Feld ausfüllen"),
    "INVALID_INPUT_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der eingegebene URL entspricht nicht dem erwarteten Format.\n Beispiel für das richtige Format: https://etrax.at"),
    "LOGIN" : MessageLookupByLibrary.simpleMessage("Anmelden"),
    "LOGIN_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der eingegebene Username oder das Password ist falsch"),
    "LOGIN_HEADING" : MessageLookupByLibrary.simpleMessage("Anmelden:"),
    "NETWORK_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Ihr Gerät ist offline."),
    "PASSWORD" : MessageLookupByLibrary.simpleMessage("Passwort"),
    "SERVER_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der Server ist derzeit nicht erreichbar."),
    "SERVER_URL_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Der angegebene URL zeigt zu keinem eTrax|rescue Server, bzw. dieser ist derzeit nicht erreichbar."),
    "UNEXPECTED_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Ein unerwarteter Fehler ist aufgetreten."),
    "USERNAME" : MessageLookupByLibrary.simpleMessage("Benutzername")
  };
}
