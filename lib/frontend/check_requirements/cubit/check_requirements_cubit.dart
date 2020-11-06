import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/app_configuration.dart';
import '../../../backend/types/app_connection.dart';
import '../../../backend/types/authentication_data.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/clear_location_cache.dart';
import '../../../backend/usecases/clear_mission_details.dart';
import '../../../backend/usecases/clear_mission_state.dart';
import '../../../backend/usecases/clear_search_areas.dart';
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
import '../../../backend/usecases/trigger_quick_action.dart';
import '../../util/translate_error_messages.dart';

part 'check_requirements_state.dart';

enum SequenceStep {
  getSettings,
  checkPermissions,
  checkServices,
  getLastLocation,
  quickAction,
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
  quickAction,
}

class CheckRequirementsCubit extends Cubit<CheckRequirementsState> {
  CheckRequirementsCubit({
    @required this.setSelectedUserState,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.getAppConfiguration,
    @required this.getSelectedMission,
    @required this.requestLocationPermission,
    @required this.requestLocationService,
    @required this.getLastLocation,
    @required this.stopLocationUpdates,
    @required this.startLocationUpdates,
    @required this.triggerQuickAction,
    @required this.logout,
    @required this.clearMissionState,
    @required this.clearMissionDetails,
    @required this.clearLocationCache,
    @required this.clearSearchAreas,
  })  : assert(setSelectedUserState != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(getAppConfiguration != null),
        assert(getSelectedMission != null),
        assert(requestLocationPermission != null),
        assert(requestLocationService != null),
        assert(getLastLocation != null),
        assert(stopLocationUpdates != null),
        assert(startLocationUpdates != null),
        assert(triggerQuickAction != null),
        assert(logout != null),
        assert(clearMissionState != null),
        assert(clearMissionDetails != null),
        assert(clearLocationCache != null),
        assert(clearSearchAreas != null),
        super(CheckRequirementsState.initial()) {
    // Initialize the map that translates sequence step positions to functions
    _stepMap = {
      SequenceStep.getSettings: retrieveSettings,
      SequenceStep.checkPermissions: locationPermissionCheck,
      SequenceStep.checkServices: locationServicesCheck,
      SequenceStep.getLastLocation: getLocation,
      SequenceStep.quickAction: quickAction,
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
  final SetSelectedUserState setSelectedUserState;
  final RequestLocationPermission requestLocationPermission;
  final RequestLocationService requestLocationService;
  final GetLastLocation getLastLocation;
  final StopLocationUpdates stopLocationUpdates;
  final StartLocationUpdates startLocationUpdates;
  final TriggerQuickAction triggerQuickAction;
  final Logout logout;
  final ClearMissionState clearMissionState;
  final ClearMissionDetails clearMissionDetails;
  final ClearLocationCache clearLocationCache;
  final ClearSearchAreas clearSearchAreas;

  Map<SequenceStep, Function> _stepMap;

  void start({
    @required StatusAction action,
    @required UserState currentState,
    @required UserState desiredState,
    @required String notificationTitle,
    @required String notificationBody,
  }) async {
    emit(state.copyWith(
      sequence: _generateSequence(action, currentState, desiredState),
      sequenceStatus:
          _generateSequenceStatus(currentStatus: StepStatus.disabled),
      currentState: currentState,
      desiredState: desiredState,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    ));
    _next();
  }

  void retrieveSettings() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final getAppConnectionEither = await getAppConnection(NoParams());
    getAppConnectionEither.fold((failure) async {
      emitFailure(failure);
    }, (appConnection) async {
      final getAuthenticationDataEither =
          await getAuthenticationData(NoParams());

      getAuthenticationDataEither.fold((failure) async {
        emit(state.copyWith(
          sequenceStatus:
              _generateSequenceStatus(currentStatus: StepStatus.failure),
          messageKey: mapFailureToMessageKey(failure),
        ));
      }, (authenticationData) async {
        final getAppConfigurationEither = await getAppConfiguration(NoParams());

        getAppConfigurationEither.fold((failure) async {
          emitFailure(failure);
        }, (appConfiguration) async {
          emit(state.copyWith(
            sequenceStatus:
                _generateSequenceStatus(currentStatus: StepStatus.complete),
            appConnection: appConnection,
            authenticationData: authenticationData,
            appConfiguration: appConfiguration,
          ));
          _next();
        });
      });
    });
  }

  void locationPermissionCheck() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));
    final locationPermissionRequestEither =
        await requestLocationPermission(NoParams());

    locationPermissionRequestEither.fold((failure) async {
      emitFailure(failure);
    }, (permissionStatus) async {
      switch (permissionStatus) {
        case PermissionStatus.denied:
          emit(state.copyWith(
              sequenceStatus:
                  _generateSequenceStatus(currentStatus: StepStatus.failure),
              messageKey: FailureMessageKey.locationPermissionDenied));
          break;
        case PermissionStatus.deniedForever:
          emit(state.copyWith(
              sequenceStatus:
                  _generateSequenceStatus(currentStatus: StepStatus.failure),
              messageKey:
                  FailureMessageKey.locationPermissionPermanentlyDenied));
          break;
        case PermissionStatus.granted:
          emit(state.copyWith(
            sequenceStatus:
                _generateSequenceStatus(currentStatus: StepStatus.complete),
          ));
          _next();
          break;
      }
    });
  }

  void locationServicesCheck() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final locationServicesRequestEither = await requestLocationService(
        RequestLocationServiceParams(
            accuracy: _mapUserStateLocationAccuracy(
                state.desiredState.locationAccuracy),
            appConfiguration: state.appConfiguration));

    locationServicesRequestEither.fold((failure) async {
      emitFailure(failure);
    }, (enabled) async {
      if (enabled == true) {
        emit(state.copyWith(
          sequenceStatus:
              _generateSequenceStatus(currentStatus: StepStatus.complete),
        ));

        _next();
      } else {
        emit(state.copyWith(
            sequenceStatus:
                _generateSequenceStatus(currentStatus: StepStatus.failure),
            messageKey: FailureMessageKey.locationServicesDisabled));
      }
    });
  }

  void getLocation() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final getLastLocationEither = await getLastLocation(NoParams());

    getLastLocationEither.fold((failure) async {
      emit(state.copyWith(
          sequenceStatus:
              _generateSequenceStatus(currentStatus: StepStatus.complete)));

      // Even though we couldn't get a fix on the location, still continue the
      // sequence...
      _next();
    }, (location) async {
      emit(state.copyWith(
        currentLocation: location,
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.complete),
      ));

      _next();
    });
  }

  void updateState() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final setStateEither =
        await setSelectedUserState(SetSelectedUserStateParams(
      appConnection: state.appConnection,
      authenticationData: state.authenticationData,
      state: state.desiredState,
    ));

    setStateEither.fold((failure) async {
      emitFailure(failure);
    }, (_) async {
      emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.complete),
      ));

      _next();
    });
  }

  void quickAction() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final quickActionEither = await triggerQuickAction(TriggerQuickActionParams(
      appConnection: state.appConnection,
      authenticationData: state.authenticationData,
      action: state.desiredState,
      currentLocation: state.currentLocation,
    ));

    quickActionEither.fold((failure) async {
      emitFailure(failure);
    }, (_) async {
      emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.complete),
      ));

      _next();
    });
  }

  void signout() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));
    final logoutEither = await logout(LogoutParams(
        appConnection: state.appConnection,
        authenticationData: state.authenticationData));
    logoutEither.fold((failure) async {
      emitFailure(failure);
    }, (_) async {
      emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.complete),
      ));

      _next();
    });
  }

  void stopUpdates() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());
    stopLocationUpdatesEither.fold((failure) async {
      emitFailure(failure);
    }, (stopped) async {
      if (stopped == true) {
        emit(state.copyWith(
            sequenceStatus:
                _generateSequenceStatus(currentStatus: StepStatus.complete)));

        _next();
      } else {
        emit(state.copyWith(
            sequenceStatus:
                _generateSequenceStatus(currentStatus: StepStatus.failure),
            messageKey: FailureMessageKey.unexpected));
      }
    });
  }

  void startUpdates() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final getSelectedMissionEither = await getSelectedMission(NoParams());
    getSelectedMissionEither.fold((failure) async {
      emitFailure(failure);
    }, (selectedMission) async {
      final startLocationUpdatesEither = await startLocationUpdates(
        StartLocationUpdatesParams(
          accuracy: _mapUserStateLocationAccuracy(
              state.desiredState.locationAccuracy),
          appConfiguration: state.appConfiguration,
          notificationTitle: state.notificationTitle,
          notificationBody: state.notificationBody,
          appConnection: state.appConnection,
          authenticationData: state.authenticationData,
          label: selectedMission.id.toString(),
        ),
      );

      startLocationUpdatesEither.fold((failure) async {
        emitFailure(failure);
      }, (success) async {
        if (success == true) {
          emit(state.copyWith(
              sequenceStatus:
                  _generateSequenceStatus(currentStatus: StepStatus.complete)));

          _next();
        } else {
          emit(state.copyWith(
              sequenceStatus:
                  _generateSequenceStatus(currentStatus: StepStatus.failure),
              messageKey: FailureMessageKey.unexpected));
        }
      });
    });
  }

  void clearState() async {
    emit(state.copyWith(
        sequenceStatus:
            _generateSequenceStatus(currentStatus: StepStatus.loading)));

    final clearMissionStateEither = await clearMissionState(NoParams());
    clearMissionStateEither.fold((failure) async {
      emitFailure(failure);
    }, (_) async {
      final clearMissionDetailsEither = await clearMissionDetails(NoParams());

      clearMissionDetailsEither.fold((failure) async {
        emitFailure(failure);
      }, (_) async {
        final clearSearchAreasEither = await clearSearchAreas(NoParams());

        clearSearchAreasEither.fold((failure) async {
          emitFailure(failure);
        }, (_) async {
          final clearLocationCacheEither = await clearLocationCache(NoParams());

          clearLocationCacheEither.fold((failure) async {
            emitFailure(failure);
          }, (_) async {
            emit(state.copyWith(
                sequenceStatus: _generateSequenceStatus(
                    currentStatus: StepStatus.complete)));

            _next();
          });
        });
      });
    });
  }

  void emitFailure(failure) {
    emit(state.copyWith(
      sequenceStatus:
          _generateSequenceStatus(currentStatus: StepStatus.failure),
      messageKey: mapFailureToMessageKey(failure),
    ));
  }

  List<SequenceStep> _generateSequence(
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
          SequenceStep.getSettings,
          SequenceStep.checkPermissions,
          SequenceStep.checkServices,
          SequenceStep.startUpdates,
        ];
      } else {
        // This only happens when we are sent here to refresh a state that
        // doesn't require location updates. Therefore we don't have to do
        // anything. Ideally we send the users back to the page they came from.
        return [];
      }
    } else if (action == StatusAction.logout) {
      if ((currentState?.locationAccuracy ?? 1) > 0) {
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
    } else if (action == StatusAction.quickAction) {
      if (currentState.locationAccuracy > 0) {
        return [
          SequenceStep.getSettings,
          SequenceStep.checkPermissions,
          SequenceStep.checkServices,
          SequenceStep.getLastLocation,
          SequenceStep.quickAction,
        ];
      } else {
        return [
          SequenceStep.getSettings,
          SequenceStep.quickAction,
        ];
      }
    }
  }

  List<StepStatus> _generateSequenceStatus({
    @required StepStatus currentStatus,
  }) {
    return List<StepStatus>.from(
      state.sequence.map(
        (SequenceStep step) {
          if (step.index < state.currentStep.index) {
            return StepStatus.complete;
          } else if (step.index > state.currentStep.index) {
            return StepStatus.disabled;
          } else {
            return currentStatus;
          }
        },
      ),
    );
  }

  void _next() {
    final nextIndex = state.currentIndex + 1;
    // If we reached the end of the sequence, emit the final state
    if (nextIndex >= state.sequence.length) {
      emit(state.markComplete());
      return;
    }

    final nextStep = state.sequence[nextIndex];
    // Increase the current step index
    emit(state.copyWith(currentIndex: nextIndex, currentStep: nextStep));

    // Execute the next step
    _stepMap[nextStep]();
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
