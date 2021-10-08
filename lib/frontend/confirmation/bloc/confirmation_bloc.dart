// @dart=2.9
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/missions.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/types/user_roles.dart';
import '../../../backend/usecases/delete_token.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/set_selected_mission.dart';
import '../../../backend/usecases/set_selected_user_role.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  ConfirmationBloc({
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.setSelectedMission,
    @required this.setSelectedUserRole,
    @required this.deleteToken,
  })  : assert(setSelectedMission != null),
        assert(setSelectedUserRole != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(deleteToken != null),
        super(ConfirmationInitial());

  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final SetSelectedMission setSelectedMission;
  final SetSelectedUserRole setSelectedUserRole;
  final DeleteToken deleteToken;

  @override
  Stream<ConfirmationState> mapEventToState(
    ConfirmationEvent event,
  ) async* {
    if (event is SubmitConfirmation) {
      yield ConfirmationInProgress();

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield ConfirmationError(messageKey: mapFailureToMessageKey(failure));
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          yield ConfirmationError(messageKey: mapFailureToMessageKey(failure));
        }, (authenticationData) async* {
          final setMissionEither = await setSelectedMission(
              SetSelectedMissionParams(
                  appConnection: appConnection,
                  authenticationData: authenticationData,
                  mission: event.mission));

          yield* setMissionEither.fold((failure) async* {
            if (failure is AuthenticationFailure) {
              yield ConfirmationUnrecoverableError(
                  messageKey: mapFailureToMessageKey(failure));
            } else {
              yield ConfirmationError(
                  messageKey: mapFailureToMessageKey(failure));
            }
          }, (_) async* {
            if (event.role == null) {
              yield ConfirmationSuccess();
            } else {
              final setUserRoleEither = await setSelectedUserRole(
                  SetSelectedUserRoleParams(
                      appConnection: appConnection,
                      authenticationData: authenticationData,
                      role: event.role));
              yield* setUserRoleEither.fold((failure) async* {
                yield ConfirmationError(
                    messageKey: mapFailureToMessageKey(failure));
              }, (_) async* {
                yield ConfirmationSuccess();
              });
            }
          });
        });
      });
    } else if (event is LogoutEvent) {
      await deleteToken(NoParams());
      yield ConfirmationLogoutSuccess();
    }
  }
}
