import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_states.dart';
import '../../../backend/usecases/get_app_configuration.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/set_selected_user_state.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'update_state_event.dart';
part 'update_state_state.dart';

class UpdateStateBloc extends Bloc<UpdateStateEvent, UpdateStateState> {
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final GetAppConfiguration getAppConfiguration;
  final SetSelectedUserState setSelectedUserState;
  UpdateStateBloc({
    @required this.setSelectedUserState,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.getAppConfiguration,
  })  : assert(setSelectedUserState != null),
        super(UpdateStateInitial());

  @override
  Stream<UpdateStateState> mapEventToState(
    UpdateStateEvent event,
  ) async* {
    if (event is SubmitState) {
      // TODO: Implement get App configuration, check permissions, check location services
      yield CheckingPermissionInProgress();
      await Future.delayed(const Duration(seconds: 2));
      yield LocationPermissionGranted();
      yield CheckingLocationServicesInProgress();
      await Future.delayed(const Duration(seconds: 2));
      yield LocationServicesEnabled();

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield UpdateStateError(messageKey: _mapFailureToMessage(failure));
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          yield UpdateStateError(messageKey: _mapFailureToMessage(failure));
        }, (authenticationData) async* {
          yield UpdateStateInProgress();

          final setStateEither =
              await setSelectedUserState(SetSelectedUserStateParams(
            appConnection: appConnection,
            authenticationData: authenticationData,
            state: event.state,
          ));

          yield* setStateEither.fold((failure) async* {
            yield UpdateStateError(messageKey: _mapFailureToMessage(failure));
          }, (_) async* {
            yield UpdateStateSuccess();
          });
        });
      });
    }
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
}
