import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

const UNEXPECTED_FAILURE_MESSAGE_KEY = 'UNEXPECTED_FAILURE_MESSAGE';
const NETWORK_FAILURE_MESSAGE_KEY = 'NETWORK_FAILURE_MESSAGE';
const SERVER_URL_FAILURE_MESSAGE_KEY = 'SERVER_URL_FAILURE_MESSAGE';
const SERVER_FAILURE_MESSAGE_KEY = 'SERVER_FAILURE_MESSAGE';
const CACHE_FAILURE_MESSAGE_KEY = 'CACHE_FAILURE_MESSAGE';
const INVALID_INPUT_FAILURE_MESSAGE_KEY = 'INVALID_INPUT_FAILURE_MESSAGE';
const LOGIN_FAILURE_MESSAGE_KEY = 'LOGIN_FAILURE_MESSAGE';
const AUTHENTICATION_FAILURE_MESSAGE_KEY = 'AUTHENTICATION_FAILURE_MESSAGE';

String translateErrorMessage(BuildContext context, String key) {
  switch (key) {
    case UNEXPECTED_FAILURE_MESSAGE_KEY:
      return S.of(context).UNEXPECTED_FAILURE_MESSAGE;
    case NETWORK_FAILURE_MESSAGE_KEY:
      return S.of(context).NETWORK_FAILURE_MESSAGE;
    case SERVER_URL_FAILURE_MESSAGE_KEY:
      return S.of(context).SERVER_URL_FAILURE_MESSAGE;
    case SERVER_FAILURE_MESSAGE_KEY:
      return S.of(context).SERVER_FAILURE_MESSAGE;
    case CACHE_FAILURE_MESSAGE_KEY:
      return S.of(context).CACHE_FAILURE_MESSAGE;
    case INVALID_INPUT_FAILURE_MESSAGE_KEY:
      return S.of(context).INVALID_INPUT_FAILURE_MESSAGE;
    case LOGIN_FAILURE_MESSAGE_KEY:
      return S.of(context).LOGIN_FAILURE_MESSAGE;
    case AUTHENTICATION_FAILURE_MESSAGE_KEY:
      return S.of(context).AUTHENTICATION_FAILURE_MESSAGE;
  }
  return S.of(context).UNEXPECTED_FAILURE_MESSAGE;
}
