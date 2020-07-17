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

  /// `Connect App:`
  String get APP_CONNECT_HEADING {
    return Intl.message(
      'Connect App:',
      name: 'APP_CONNECT_HEADING',
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

  /// `Login:`
  String get LOGIN_HEADING {
    return Intl.message(
      'Login:',
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

  /// `Logout`
  String get LOGOUT {
    return Intl.message(
      'Logout',
      name: 'LOGOUT',
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