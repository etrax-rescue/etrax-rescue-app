import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
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
  platform,
  locationPermissionDenied,
  locationPermissionPermanentlyDenied,
  locationServicesDisabled,
  noLockOnLocation,
}

FailureMessageKey mapFailureToMessageKey(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return FailureMessageKey.network;
    case ServerConnectionFailure:
      return FailureMessageKey.serverUrl;
    case ServerFailure:
      return FailureMessageKey.server;
    case CacheFailure:
      return FailureMessageKey.cache;
    case InvalidInputFailure:
      return FailureMessageKey.invalidInput;
    case LoginFailure:
      return FailureMessageKey.login;
    case AuthenticationFailure:
      return FailureMessageKey.authentication;
    case PlatformFailure:
      return FailureMessageKey.platform;
    case NoLockOnLocationFailure:
      return FailureMessageKey.noLockOnLocation;
    default:
      return FailureMessageKey.unexpected;
  }
}

String translateErrorMessage(BuildContext context, FailureMessageKey key) {
  key = key ?? FailureMessageKey.unexpected;

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
    case FailureMessageKey.noLockOnLocation:
      return S.of(context).NO_LOCK_ON_LOCATION_FAILURE_MESSAGE;
    case FailureMessageKey.platform:
      return S.of(context).PLATFORM_FAILURE_MESSAGE;
    default:
      return S.of(context).UNEXPECTED_FAILURE_MESSAGE;
  }
}
