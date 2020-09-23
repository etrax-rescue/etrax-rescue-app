import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../backend/types/app_configuration.dart';
import '../../../backend/types/app_connection.dart';
import '../../../backend/types/authentication_data.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/clear_location_cache.dart';
import '../../../backend/usecases/clear_mission_details.dart';
import '../../../backend/usecases/clear_mission_state.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_last_location.dart';
import '../../../backend/usecases/get_selected_mission.dart';
import '../../../backend/usecases/logout.dart';
import '../../../backend/usecases/request_location_permission.dart';
import '../../../backend/usecases/request_location_service.dart';
import '../../../backend/usecases/set_selected_user_state.dart';
import '../../../backend/usecases/start_location_updates.dart';
import '../../../backend/usecases/stop_location_updates.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'check_requirements_state.dart';

enum SequenceStep {
  getSettings,
  checkPermissions,
  checkServices,
  updateState,
  logout,
  stopUpdates,
  clearState,
  startUpdates,
}

enum StatusAction {
  change,
  refresh,
  logout,
}

class CheckRequirementsCubit extends Cubit<CheckRequirementsState> {
  CheckRequirementsCubit({
    @required this.setSelectedUserState,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.getAppConfiguration,
    @required this.getSelectedMission,
    @required this.getLastLocation,
    @required this.requestLocationPermission,
    @required this.requestLocationService,
    @required this.stopLocationUpdates,
    @required this.startLocationUpdates,
    @required this.logout,
    @required this.clearMissionState,
    @required this.clearMissionDetails,
    @required this.clearLocationCache,
  })  : assert(setSelectedUserState != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(getAppConfiguration != null),
        assert(getSelectedMission != null),
        assert(getLastLocation != null),
        assert(requestLocationPermission != null),
        assert(requestLocationService != null),
        assert(stopLocationUpdates != null),
        assert(startLocationUpdates != null),
        assert(logout != null),
        assert(clearMissionState != null),
        assert(clearMissionDetails != null),
        assert(clearLocationCache != null),
        super(CheckRequirementsState.initial()) {
    // Initialize the map that translates sequence step positions to functions
    _stepMap = {
      SequenceStep.getSettings: retrieveSettings,
      SequenceStep.checkPermissions: locationPermissionCheck,
      SequenceStep.checkServices: locationServicesCheck,
      SequenceStep.updateState: updateState,
      SequenceStep.logout: signout,
      SequenceStep.stopUpdates: stopUpdates,
      SequenceStep.clearState: clearState,
      SequenceStep.startUpdates: startUpdates,
    };
  }

  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final GetAppConfiguration getAppConfiguration;
  final GetSelectedMission getSelectedMission;
  final GetLastLocation getLastLocation;
  final SetSelectedUserState setSelectedUserState;
  final RequestLocationPermission requestLocationPermission;
  final RequestLocationService requestLocationService;
  final StopLocationUpdates stopLocationUpdates;
  final StartLocationUpdates startLocationUpdates;
  final Logout logout;
  final ClearMissionState clearMissionState;
  final ClearMissionDetails clearMissionDetails;
  final ClearLocationCache clearLocationCache;

  Map<SequenceStep, Function> _stepMap;

  List<SequenceStep> generateSequence(
      StatusAction action, UserState currentState, UserState desiredState) {
    if (action == StatusAction.change) {
      if (currentState.locationAccuracy > 0) {
        if (desiredState.locationAccuracy > 0) {
          return [
            SequenceStep.getSettings,
            SequenceStep.checkPermissions,
            SequenceStep.checkServices,
            SequenceStep.updateState,
            SequenceStep.stopUpdates,
            SequenceStep.startUpdates,
          ];
        } else {
          return [
            SequenceStep.getSettings,
            SequenceStep.updateState,
            SequenceStep.stopUpdates,
          ];
        }
      } else {
        if (desiredState.locationAccuracy > 0) {
          return [
            SequenceStep.getSettings,
            SequenceStep.checkPermissions,
            SequenceStep.checkServices,
            SequenceStep.updateState,
            SequenceStep.startUpdates,
          ];
        } else {
          return [
            SequenceStep.getSettings,
            SequenceStep.updateState,
          ];
        }
      }
    } else if (action == StatusAction.refresh) {
      if (currentState.locationAccuracy > 0) {
        return [
          SequenceStep.checkPermissions,
          SequenceStep.checkServices,
          SequenceStep.startUpdates,
        ];
      } else {
        // This only happens when we are sent here to refresh a state that
        // doesn't require location updates. Therefore we don't have to do
        // anything. Ideally send the users back to the page they came from.
        return [];
      }
    } else {
      if (currentState.locationAccuracy > 0) {
        return [
          SequenceStep.getSettings,
          SequenceStep.logout,
          SequenceStep.stopUpdates,
          SequenceStep.clearState,
        ];
      } else {
        return [
          SequenceStep.getSettings,
          SequenceStep.logout,
          SequenceStep.clearState,
        ];
      }
    }
  }

  void start(
      StatusAction action,
      UserState currentState,
      UserState desiredState,
      String notificationTitle,
      String notificationBody) async {
    final sequence = generateSequence(action, currentState, desiredState);
    emit(state.copyWith(
      sequence: sequence,
      status: CheckRequirementsStatus.started,
      subStatus: CheckRequirementsSubStatus.loading,
      currentState: currentState,
      desiredState: desiredState,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    ));
    _next();
  }

  void retrieveSettings() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.settings,
        subStatus: CheckRequirementsSubStatus.loading));

    final getAppConnectionEither = await getAppConnection(NoParams());
    getAppConnectionEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.settings,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (appConnection) async {
      final getAuthenticationDataEither =
          await getAuthenticationData(NoParams());

      getAuthenticationDataEither.fold((failure) async {
        emit(state.copyWith(
          status: CheckRequirementsStatus.settings,
          subStatus: CheckRequirementsSubStatus.failure,
          messageKey: _mapFailureToMessageKey(failure),
        ));
      }, (authenticationData) async {
        final getAppConfigurationEither = await getAppConfiguration(NoParams());

        getAppConfigurationEither.fold((failure) async {
          emit(state.copyWith(
            status: CheckRequirementsStatus.settings,
            subStatus: CheckRequirementsSubStatus.failure,
            messageKey: _mapFailureToMessageKey(failure),
          ));
        }, (appConfiguration) async {
          final getSelectedMissionEither = await getSelectedMission(NoParams());
          getSelectedMissionEither.fold((failure) async {
            emit(state.copyWith(
              status: CheckRequirementsStatus.settings,
              subStatus: CheckRequirementsSubStatus.failure,
              messageKey: _mapFailureToMessageKey(failure),
            ));
          }, (selectedMission) async {
            emit(state.copyWith(
              status: CheckRequirementsStatus.settings,
              subStatus: CheckRequirementsSubStatus.success,
              appConnection: appConnection,
              authenticationData: authenticationData,
              appConfiguration: appConfiguration,
              label: selectedMission.id.toString(),
            ));
            _next();
          });
        });
      });
    });
  }

  void locationPermissionCheck() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.locationPermission,
        subStatus: CheckRequirementsSubStatus.loading));
    final locationPermissionRequestEither =
        await requestLocationPermission(NoParams());

    locationPermissionRequestEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.locationPermission,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (permissionStatus) async {
      switch (permissionStatus) {
        case PermissionStatus.denied:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermission,
              subStatus: CheckRequirementsSubStatus.result1));
          break;
        case PermissionStatus.deniedForever:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermission,
              subStatus: CheckRequirementsSubStatus.result2));
          break;
        case PermissionStatus.granted:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermission,
              subStatus: CheckRequirementsSubStatus.success));
          _next();
          break;
      }
    });
  }

  void locationServicesCheck() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.locationServices,
        subStatus: CheckRequirementsSubStatus.loading));

    final locationServicesRequestEither = await requestLocationService(
        RequestLocationServiceParams(
            accuracy: _mapUserStateLocationAccuracy(
                state.desiredState.locationAccuracy),
            appConfiguration: state.appConfiguration));

    locationServicesRequestEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.locationServices,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (enabled) async {
      if (enabled == true) {
        emit(state.copyWith(
            status: CheckRequirementsStatus.locationServices,
            subStatus: CheckRequirementsSubStatus.success));

        _next();
      } else {
        emit(state.copyWith(
            status: CheckRequirementsStatus.locationServices,
            subStatus: CheckRequirementsSubStatus.result1));
      }
    });
  }

  /*
  void getLocation() async {
    final getLastLocationEither = await getLastLocation(NoParams());
    getLastLocationEither.fold((failure) {
      // TODO: handle failure
      emit(state.copyWith(
          status: CheckRequirementsStatus.getLastLocation,
          subStatus: CheckRequirementsSubStatus.failure,
          messageKey: _mapFailureToMessageKey(failure)));
      print(failure);
    }, (locationData) {
      print(locationData);
      emit(state.copyWith(
          status: CheckRequirementsStatus.getLastLocation,
          subStatus: CheckRequirementsSubStatus.success,
          currentLocation: locationData));

      _next();
    });
  }*/

  void updateState() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.setState,
        subStatus: CheckRequirementsSubStatus.loading));

    final setStateEither =
        await setSelectedUserState(SetSelectedUserStateParams(
      appConnection: state.appConnection,
      authenticationData: state.authenticationData,
      state: state.desiredState,
      currentLocation: null,
    ));

    setStateEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.setState,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (_) async {
      emit(state.copyWith(
          status: CheckRequirementsStatus.setState,
          subStatus: CheckRequirementsSubStatus.success));

      _next();
    });
  }

  void signout() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.logout,
        subStatus: CheckRequirementsSubStatus.loading));
    final logoutEither = await logout(NoParams());
    logoutEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.logout,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (_) async {
      emit(state.copyWith(
          status: CheckRequirementsStatus.logout,
          subStatus: CheckRequirementsSubStatus.success));

      _next();
    });
  }

  void stopUpdates() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.stopUpdates,
        subStatus: CheckRequirementsSubStatus.loading));

    final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());
    stopLocationUpdatesEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.stopUpdates,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (stopped) async {
      if (stopped == true) {
        emit(state.copyWith(
            status: CheckRequirementsStatus.stopUpdates,
            subStatus: CheckRequirementsSubStatus.success));

        _next();
      } else {
        // TODO: add proper message key
        emit(state.copyWith(
            status: CheckRequirementsStatus.stopUpdates,
            subStatus: CheckRequirementsSubStatus.failure));
      }
    });
  }

  void startUpdates() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.startUpdates,
        subStatus: CheckRequirementsSubStatus.loading));
    final startLocationUpdatesEither = await startLocationUpdates(
      StartLocationUpdatesParams(
        accuracy:
            _mapUserStateLocationAccuracy(state.desiredState.locationAccuracy),
        appConfiguration: state.appConfiguration,
        notificationTitle: state.notificationTitle,
        notificationBody: state.notificationBody,
        appConnection: state.appConnection,
        authenticationData: state.authenticationData,
        label: state.label,
      ),
    );

    startLocationUpdatesEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.startUpdates,
        subStatus: CheckRequirementsSubStatus.failure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (success) async {
      if (success == true) {
        emit(state.copyWith(
            status: CheckRequirementsStatus.startUpdates,
            subStatus: CheckRequirementsSubStatus.success));

        _next();
      } else {
        // TODO: add proper message key
        emit(state.copyWith(
            status: CheckRequirementsStatus.startUpdates,
            subStatus: CheckRequirementsSubStatus.failure));
      }
    });
  }

  void clearState() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.clearState,
        subStatus: CheckRequirementsSubStatus.loading));

    final clearMissionStateEither = await clearMissionState(NoParams());
    clearMissionStateEither.fold((failure) async {
      // TODO: handle failure
    }, (_) async {
      final clearMissionDetailsEither = await clearMissionDetails(NoParams());

      clearMissionDetailsEither.fold((failure) async {
        // TODO: handle failure
      }, (_) async {
        final clearLocationCacheEither = await clearLocationCache(NoParams());

        clearLocationCacheEither.fold((failure) async {
          // TODO: handle failure
        }, (_) async {
          emit(state.copyWith(
              status: CheckRequirementsStatus.clearState,
              subStatus: CheckRequirementsSubStatus.success));

          _next();
        });
      });
    });
  }

  void _next() {
    final nextStep = state.currentStep + 1;
    if (nextStep >= state.sequence.length) {
      emit(state.copyWith(
          status: CheckRequirementsStatus.complete,
          subStatus: CheckRequirementsSubStatus.success));
      return;
    }

    final nextAction = state.sequence[nextStep];
    _stepMap[nextAction]();
  }

  FailureMessageKey _mapFailureToMessageKey(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return FailureMessageKey.network;
      case ServerFailure:
        return FailureMessageKey.serverUrl;
      case CacheFailure:
        return FailureMessageKey.cache;
      case AuthenticationFailure:
        return FailureMessageKey.authentication;
      default:
        return FailureMessageKey.unexpected;
    }
  }

  LocationAccuracy _mapUserStateLocationAccuracy(int accuracy) {
    switch (accuracy) {
      case 0:
        return LocationAccuracy.powerSave;
        break;
      case 1:
        return LocationAccuracy.low;
        break;
      case 2:
        return LocationAccuracy.balanced;
        break;
      case 3:
        return LocationAccuracy.high;
        break;
      case 4:
        return LocationAccuracy.high;
        break;
      default:
        return LocationAccuracy.balanced;
        break;
    }
  }
}
