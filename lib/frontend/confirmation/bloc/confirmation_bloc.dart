import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/missions.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_roles.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/set_selected_mission.dart';
import '../../../backend/usecases/set_selected_user_role.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final SetSelectedMission setSelectedMission;
  final SetSelectedUserRole setSelectedUserRole;
  ConfirmationBloc({
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.setSelectedMission,
    @required this.setSelectedUserRole,
  })  : assert(setSelectedMission != null),
        assert(setSelectedUserRole != null),
        super(ConfirmationInitial());

  @override
  Stream<ConfirmationState> mapEventToState(
    ConfirmationEvent event,
  ) async* {
    if (event is SubmitConfirmation) {
      yield ConfirmationInProgress();

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield ConfirmationError(messageKey: _mapFailureToMessage(failure));
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          yield ConfirmationError(messageKey: _mapFailureToMessage(failure));
        }, (authenticationData) async* {
          final setMissionEither = await setSelectedMission(
              SetSelectedMissionParams(
                  appConnection: appConnection,
                  authenticationData: authenticationData,
                  mission: event.mission));
          yield* setMissionEither.fold((failure) async* {
            yield ConfirmationError(messageKey: _mapFailureToMessage(failure));
          }, (_) async* {
            final setUserRoleEither = await setSelectedUserRole(
                SetSelectedUserRoleParams(
                    appConnection: appConnection,
                    authenticationData: authenticationData,
                    role: event.role));
            yield* setUserRoleEither.fold((failure) async* {
              yield ConfirmationError(
                  messageKey: _mapFailureToMessage(failure));
            }, (_) async* {
              yield ConfirmationSuccess();
            });
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
