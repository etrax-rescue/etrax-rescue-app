// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "APP_CONNECT_HEADING" : MessageLookupByLibrary.simpleMessage("Connect App:"),
    "AUTHENTICATION_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Access rights to the ressources on the server expired. Please log in again."),
    "AUTHENTICATION_SUCCESS" : MessageLookupByLibrary.simpleMessage("Success!"),
    "BACK" : MessageLookupByLibrary.simpleMessage("Go back"),
    "CACHE_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("An error occured during the URI storage process."),
    "CONNECT" : MessageLookupByLibrary.simpleMessage("Connect"),
    "FIELD_REQUIRED" : MessageLookupByLibrary.simpleMessage("required"),
    "INVALID_INPUT_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("The provided URL does not resemble a valid format.\n Example for a valid URL: https://etrax.at"),
    "LOGIN" : MessageLookupByLibrary.simpleMessage("Login"),
    "LOGIN_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Invalid username or password"),
    "LOGIN_HEADING" : MessageLookupByLibrary.simpleMessage("Login:"),
    "LOGOUT" : MessageLookupByLibrary.simpleMessage("Logout"),
    "MISSIONS" : MessageLookupByLibrary.simpleMessage("Missions"),
    "NETWORK_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Your device is offline."),
    "PASSWORD" : MessageLookupByLibrary.simpleMessage("Password"),
    "RETRY" : MessageLookupByLibrary.simpleMessage("Retry"),
    "SERVER_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("The server is not reachable at the moment."),
    "SERVER_URL_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("Either the provided URI doesn\'t point to a valid eTrax|rescue Server,\n or the server is not reachable at the moment."),
    "UNEXPECTED_FAILURE_MESSAGE" : MessageLookupByLibrary.simpleMessage("A unexpected error occured."),
    "USERNAME" : MessageLookupByLibrary.simpleMessage("Username")
  };
}
