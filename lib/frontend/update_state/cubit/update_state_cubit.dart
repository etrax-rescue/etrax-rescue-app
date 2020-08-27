import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/usecases/request_location_service.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/app_configuration.dart';
import '../../../backend/types/app_connection.dart';
import '../../../backend/types/authentication_data.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/has_location_permission.dart';
import '../../../backend/usecases/request_location_permission.dart';
import '../../../backend/usecases/set_selected_user_state.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'update_state_state.dart';

class UpdateStateCubit extends Cubit<UpdateStateState> {
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final GetAppConfiguration getAppConfiguration;
  final SetSelectedUserState setSelectedUserState;
  final RequestLocationPermission requestLocationPermission;
  final RequestLocationService requestLocationService;

  UpdateStateCubit({
    @required this.setSelectedUserState,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.getAppConfiguration,
    @required this.requestLocationPermission,
    @required this.requestLocationService,
  })  : assert(setSelectedUserState != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(getAppConfiguration != null),
        assert(requestLocationPermission != null),
        assert(requestLocationService != null),
        super(UpdateStateInitial());

  //! Should we keep the state here in the Cubit, or in the widget's state?
  UserState _userState;
  AppConnection _appConnection;
  AuthenticationData _authenticationData;
  AppConfiguration _appConfiguration;

  set userState(UserState state) {
    this._userState = state;
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
          locationPermissionCheck();
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
      emit(UpdateStateError(messageKey: UNEXPECTED_FAILURE_MESSAGE_KEY));
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
      emit(UpdateStateError(messageKey: UNEXPECTED_FAILURE_MESSAGE_KEY));
    }

    emit(UpdateStateInProgress());

    final setStateEither =
        await setSelectedUserState(SetSelectedUserStateParams(
      appConnection: this._appConnection,
      authenticationData: this._authenticationData,
      state: this._userState,
    ));

    setStateEither.fold((failure) async* {
      emit(UpdateStateError(messageKey: _mapFailureToMessage(failure)));
    }, (_) async* {
      emit(UpdateStateSuccess());
    });
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
