import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

enum FailureMessageKey {
  unexpected,
  network,
  serverUrl,
  server,
  cache,
  invalidInput,
  login,
  authentication,
  locationPermissionDenied,
  locationPermissionPermanentlyDenied,
  locationServicesDisabled,
}

String translateErrorMessage(BuildContext context, FailureMessageKey key) {
  key = key ?? '';

  switch (key) {
    case FailureMessageKey.unexpected:
      return S.of(context).UNEXPECTED_FAILURE_MESSAGE;
    case FailureMessageKey.network:
      return S.of(context).NETWORK_FAILURE_MESSAGE;
    case FailureMessageKey.serverUrl:
      return S.of(context).SERVER_URL_FAILURE_MESSAGE;
    case FailureMessageKey.server:
      return S.of(context).SERVER_FAILURE_MESSAGE;
    case FailureMessageKey.cache:
      return S.of(context).CACHE_FAILURE_MESSAGE;
    case FailureMessageKey.invalidInput:
      return S.of(context).INVALID_INPUT_FAILURE_MESSAGE;
    case FailureMessageKey.login:
      return S.of(context).LOGIN_FAILURE_MESSAGE;
    case FailureMessageKey.authentication:
      return S.of(context).AUTHENTICATION_FAILURE_MESSAGE;
    case FailureMessageKey.locationPermissionDenied:
      return S.of(context).LOCATION_PERMISSION_DENIED_FAILURE_MESSAGE;
    case FailureMessageKey.locationPermissionPermanentlyDenied:
      return S
          .of(context)
          .LOCATION_PERMISSION_PERMANENTLY_DENIED_FAILURE_MESSAGE;
    case FailureMessageKey.locationServicesDisabled:
      return S.of(context).LOCATION_SERVICES_DISABLED_FAILURE_MESSAGE;
    default:
      return S.of(context).UNEXPECTED_FAILURE_MESSAGE;
  }
}
