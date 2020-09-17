import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/app_configuration.dart';
import '../../../backend/types/app_connection.dart';
import '../../../backend/types/authentication_data.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/get_selected_mission.dart';
import '../../../backend/usecases/request_location_permission.dart';
import '../../../backend/usecases/request_location_service.dart';
import '../../../backend/usecases/set_selected_user_state.dart';
import '../../../backend/usecases/start_location_updates.dart';
import '../../../backend/usecases/stop_location_updates.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'check_requirements_state.dart';

class CheckRequirementsCubit extends Cubit<CheckRequirementsState> {
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final GetAppConfiguration getAppConfiguration;
  final GetSelectedMission getSelectedMission;
  final SetSelectedUserState setSelectedUserState;
  final RequestLocationPermission requestLocationPermission;
  final RequestLocationService requestLocationService;
  final StopLocationUpdates stopLocationUpdates;
  final StartLocationUpdates startLocationUpdates;

  CheckRequirementsCubit({
    @required this.setSelectedUserState,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.getAppConfiguration,
    @required this.getSelectedMission,
    @required this.requestLocationPermission,
    @required this.requestLocationService,
    @required this.stopLocationUpdates,
    @required this.startLocationUpdates,
  })  : assert(setSelectedUserState != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(getAppConfiguration != null),
        assert(getSelectedMission != null),
        assert(requestLocationPermission != null),
        assert(requestLocationService != null),
        assert(stopLocationUpdates != null),
        assert(startLocationUpdates != null),
        super(CheckRequirementsState.initial());

  void start(UserState desiredState, String notificationTitle,
      String notificationBody) async {
    emit(state.copyWith(
      status: CheckRequirementsStatus.started,
      userState: desiredState,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
    ));
    retrieveSettings();
  }

  void retrieveSettings() async {
    emit(state.copyWith(status: CheckRequirementsStatus.settingsLoading));

    final getAppConnectionEither = await getAppConnection(NoParams());
    getAppConnectionEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.settingsFailure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (appConnection) async {
      final getAuthenticationDataEither =
          await getAuthenticationData(NoParams());

      getAuthenticationDataEither.fold((failure) async {
        emit(state.copyWith(
          status: CheckRequirementsStatus.settingsFailure,
          messageKey: _mapFailureToMessageKey(failure),
        ));
      }, (authenticationData) async {
        final getAppConfigurationEither = await getAppConfiguration(NoParams());

        getAppConfigurationEither.fold((failure) async {
          emit(state.copyWith(
            status: CheckRequirementsStatus.settingsFailure,
            messageKey: _mapFailureToMessageKey(failure),
          ));
        }, (appConfiguration) async {
          final getSelectedMissionEither = await getSelectedMission(NoParams());
          getSelectedMissionEither.fold((failure) async {
            emit(state.copyWith(
              status: CheckRequirementsStatus.settingsFailure,
              messageKey: _mapFailureToMessageKey(failure),
            ));
          }, (selectedMission) async {
            emit(state.copyWith(
              status: CheckRequirementsStatus.settingsSuccess,
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
        status: CheckRequirementsStatus.locationPermissionLoading));
    final locationPermissionRequestEither =
        await requestLocationPermission(NoParams());

    locationPermissionRequestEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.locationPermissionFailure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (permissionStatus) async {
      switch (permissionStatus) {
        case PermissionStatus.granted:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermissionSuccess));
          locationServicesCheck();
          break;
        case PermissionStatus.denied:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermissionDenied));
          break;
        case PermissionStatus.deniedForever:
          emit(state.copyWith(
              status: CheckRequirementsStatus.locationPermissionDeniedForever));
          break;
      }
    });
  }

  void locationServicesCheck() async {
    emit(state.copyWith(
        status: CheckRequirementsStatus.locationServicesLoading));

    final locationServicesRequestEither = await requestLocationService(
        RequestLocationServiceParams(
            accuracy:
                _mapUserStateLocationAccuracy(state.userState.locationAccuracy),
            appConfiguration: state.appConfiguration));

    locationServicesRequestEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.locationServicesFailure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (enabled) async {
      if (enabled == true) {
        emit(state.copyWith(
            status: CheckRequirementsStatus.locationServicesSuccess));
        updateState();
      } else {
        emit(state.copyWith(
            status: CheckRequirementsStatus.locationServicesDisabled));
      }
    });
  }

  void updateState() async {
    emit(state.copyWith(status: CheckRequirementsStatus.setStateLoading));

    final setStateEither =
        await setSelectedUserState(SetSelectedUserStateParams(
      appConnection: state.appConnection,
      authenticationData: state.authenticationData,
      state: state.userState,
    ));

    setStateEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.setStateFailure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (_) async {
      emit(state.copyWith(status: CheckRequirementsStatus.setStateSuccess));
      stopUpdates();
    });
  }

  void stopUpdates() async {
    emit(state.copyWith(status: CheckRequirementsStatus.stopUpdatesLoading));

    final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());
    stopLocationUpdatesEither.fold((failure) async {
      emit(state.copyWith(
        status: CheckRequirementsStatus.stopUpdatesFailure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (stopped) async {
      if (stopped == true) {
        emit(
            state.copyWith(status: CheckRequirementsStatus.stopUpdatesSuccess));
        if (state.userState.locationAccuracy == 0) {
          emit(state.copyWith(status: CheckRequirementsStatus.success));
        } else {
          startUpdates();
        }
      } else {
        // TODO: add proper message key
        emit(
            state.copyWith(status: CheckRequirementsStatus.stopUpdatesFailure));
      }
    });
  }

  void startUpdates() async {
    emit(state.copyWith(status: CheckRequirementsStatus.startUpdatesLoading));
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
        status: CheckRequirementsStatus.startUpdatesFailure,
        messageKey: _mapFailureToMessageKey(failure),
      ));
    }, (success) async {
      if (success == true) {
        emit(state.copyWith(
            status: CheckRequirementsStatus.startUpdatesSuccess));
        emit(state.copyWith(status: CheckRequirementsStatus.success));
      } else {
        // TODO: add proper message key
        emit(state.copyWith(
            status: CheckRequirementsStatus.startUpdatesFailure));
      }
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
