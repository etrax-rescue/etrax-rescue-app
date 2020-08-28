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
    @required this.requestLocationPermission,
    @required this.requestLocationService,
    @required this.stopLocationUpdates,
    @required this.startLocationUpdates,
  })  : assert(setSelectedUserState != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(getAppConfiguration != null),
        assert(requestLocationPermission != null),
        assert(requestLocationService != null),
        assert(stopLocationUpdates != null),
        assert(startLocationUpdates != null),
        super(UpdateStateInitial());

  //! Should we keep the state here in the Cubit, or in the widget's state?
  UserState _userState;
  AppConnection _appConnection;
  AuthenticationData _authenticationData;
  AppConfiguration _appConfiguration;

  String _notificationTitle;
  String _notificationBody;
  String _label;

  void start(UserState desiredState, String notificationTitle,
      String notificationBody) async {
    this._userState = desiredState;
    this._notificationTitle = notificationTitle;
    this._notificationBody = notificationBody;
    this._label = desiredState.name;

    retrieveSettings();
  }

  void retrieveSettings() async {
    emit(RetrievingSettingsInProgress());
    final getAppConnectionEither = await getAppConnection(NoParams());
    getAppConnectionEither.fold((failure) async {
      // TODO: handle failure
    }, (appConnection) async {
      this._appConnection = appConnection;
      final getAuthenticationDataEither =
          await getAuthenticationData(NoParams());

      getAuthenticationDataEither.fold((failure) async {
        // TODO: handle failure
      }, (authenticationData) async {
        this._authenticationData = authenticationData;
        final getAppConfigurationEither = await getAppConfiguration(NoParams());

        getAppConfigurationEither.fold((failure) async {
          // TODO: handle failure
        }, (appConfiguration) async {
          this._appConfiguration = appConfiguration;
          emit(RetrievingSettingsSuccess());
          if (this._userState.locationAccuracy == 0) {
            updateState();
          } else {
            locationPermissionCheck();
          }
        });
      });
    });
  }

  void locationPermissionCheck() async {
    emit(LocationPermissionInProgress());
    final locationPermissionRequestEither =
        await requestLocationPermission(NoParams());

    locationPermissionRequestEither.fold((failure) async {
      // TODO: Handle PlatformFailure
    }, (permissionStatus) async {
      emit(LocationPermissionResult(permissionStatus: permissionStatus));

      if (permissionStatus == PermissionStatus.granted) {
        locationServicesCheck();
      }
    });
  }

  void locationServicesCheck() async {
    if (this._userState == null || this._appConfiguration == null) {
      emit(LocationServicesError(messageKey: UNEXPECTED_FAILURE_MESSAGE_KEY));
    }
    emit(LocationServicesInProgress());
    final locationServicesRequestEither = await requestLocationService(
        RequestLocationServiceParams(
            accuracy:
                _mapUserStateLocationAccuracy(this._userState.locationAccuracy),
            appConfiguration: this._appConfiguration));

    locationServicesRequestEither.fold((failure) async {
      // TODO: Handle PlatformFailure
    }, (enabled) async {
      emit(LocationServicesResult(enabled: enabled));
      print(enabled);

      if (enabled == true) {
        updateState();
      }
    });
  }

  void updateState() async {
    if (this._userState == null ||
        this._appConnection == null ||
        this._authenticationData == null) {
      emit(SetStateError(messageKey: UNEXPECTED_FAILURE_MESSAGE_KEY));
    }

    emit(SetStateInProgress());

    final setStateEither =
        await setSelectedUserState(SetSelectedUserStateParams(
      appConnection: this._appConnection,
      authenticationData: this._authenticationData,
      state: this._userState,
    ));

    setStateEither.fold((failure) async {
      emit(SetStateError(messageKey: _mapFailureToMessage(failure)));
    }, (_) async {
      emit(SetStateSuccess());
      stopUpdates();
    });
  }

  void stopUpdates() async {
    emit(StopUpdatesInProgress());
    final stopLocationUpdatesEither = await stopLocationUpdates(NoParams());
    stopLocationUpdatesEither.fold((failure) async {
      // TODO: handle failure
    }, (stopped) async {
      if (stopped == true) {
        emit(StopUpdatesSuccess());
        if (this._userState.locationAccuracy == 0) {
          emit(CheckRequirementsSuccess());
        } else {
          startUpdates();
        }
      } else {
        // TODO: what should we do when this returns false?
      }
    });
  }

  void startUpdates() async {
    emit(StartUpdatesInProgress());
    final startLocationUpdatesEither = await startLocationUpdates(
      StartLocationUpdatesParams(
        accuracy:
            _mapUserStateLocationAccuracy(this._userState.locationAccuracy),
        appConfiguration: this._appConfiguration,
        notificationTitle: this._notificationTitle,
        notificationBody: this._notificationBody,
        appConnection: this._appConnection,
        authenticationData: this._authenticationData,
        label: this._label,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    emit(StartUpdatesSuccess());
    emit(CheckRequirementsSuccess());
  }

  String _mapFailureToMessage(Failure failure) {
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
      case 1:
        return LocationAccuracy.low;
        break;
      case 2:
        return LocationAccuracy.balanced;
        break;
      case 3:
        return LocationAccuracy.high;
        break;
      default:
        return LocationAccuracy.balanced;
        break;
    }
  }
}
