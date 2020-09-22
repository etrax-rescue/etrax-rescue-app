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
        super(CheckRequirementsState.initial());

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

  void start(UserState desiredState, String notificationTitle,
      String notificationBody) async {
    emit(state.copyWith(
      status: CheckRequirementsStatus.started,
      subStatus: CheckRequirementsSubStatus.loading,
      userState: desiredState,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    ));
    retrieveSettings();
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

            if (state.userState.locationAccuracy == 0) {
              updateState();
            } else {
              locationPermissionCheck();
            }
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
        case PermissionStatus.granted:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermission,
              subStatus: CheckRequirementsSubStatus.success));
          locationServicesCheck();
          break;
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
      }
    });
  }

  void locationServicesCheck() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.locationServices,
        subStatus: CheckRequirementsSubStatus.loading));

    final locationServicesRequestEither = await requestLocationService(
        RequestLocationServiceParams(
            accuracy:
                _mapUserStateLocationAccuracy(state.userState.locationAccuracy),
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
        getLocation();
      } else {
        emit(state.copyWith(
            status: CheckRequirementsStatus.locationServices,
            subStatus: CheckRequirementsSubStatus.result1));
      }
    });
  }

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
      updateState();
    });
  }

  void updateState() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.setState,
        subStatus: CheckRequirementsSubStatus.loading));

    final setStateEither =
        await setSelectedUserState(SetSelectedUserStateParams(
      appConnection: state.appConnection,
      authenticationData: state.authenticationData,
      state: state.userState,
      currentLocation: state.currentLocation,
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
      stopUpdates();
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
      stopUpdates();
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
        if (state.userState.locationAccuracy == 0) {
          emit(state.copyWith(
              status: CheckRequirementsStatus.complete,
              subStatus: CheckRequirementsSubStatus.success));
        } else {
          startUpdates();
        }
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
            _mapUserStateLocationAccuracy(state.userState.locationAccuracy),
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
        emit(state.copyWith(
            status: CheckRequirementsStatus.complete,
            subStatus: CheckRequirementsSubStatus.success));
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
          emit(state.copyWith(
              status: CheckRequirementsStatus.complete,
              subStatus: CheckRequirementsSubStatus.success));
        });
      });
    });
  }

  String _mapFailureToMessageKey(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return NETWORK_FAILURE_MESSAGE_KEY;
      case ServerFailure:
        return SERVER_URL_FAILURE_MESSAGE_KEY;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE_KEY;
      default:
        return UNEXPECTED_FAILURE_MESSAGE_KEY;
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
