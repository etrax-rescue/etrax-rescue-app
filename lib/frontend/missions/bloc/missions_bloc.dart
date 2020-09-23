import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/usecases/logout.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/initialization_data.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/fetch_initialization_data.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

part 'missions_event.dart';
part 'missions_state.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc({
    @required this.fetchInitializationData,
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.logout,
  })  : assert(fetchInitializationData != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(logout != null),
        super(InitializationInitial());

  final FetchInitializationData fetchInitializationData;
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final Logout logout;

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is StartFetchingInitializationData) {
      yield InitializationInProgress(
          initializationData: state.initializationData);

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield InitializationUnrecoverableError(
            messageKey: FailureMessageKey.cache);
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          yield InitializationUnrecoverableError(
              messageKey: FailureMessageKey.cache);
        }, (authenticationData) async* {
          final initializationEither = await fetchInitializationData(
              FetchInitializationDataParams(
                  appConnection: appConnection,
                  authenticationData: authenticationData));

          yield* initializationEither.fold((failure) async* {
            yield _mapFailureToErrorState(failure);
          }, (initializationData) async* {
            yield InitializationSuccess(initializationData: initializationData);
          });
        });
      });
    } else if (event is LogoutEvent) {
      final logoutEither = await logout(NoParams());

      yield* logoutEither.fold((failure) async* {
        yield _mapFailureToErrorState(failure);
      }, (initializationData) async* {
        yield InitializationLogoutSuccess();
      });
    }
  }

  //! TODO: Update to mapFailureToMessageKey
  InitializationState _mapFailureToErrorState(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return InitializationRecoverableError(
            initializationData: state.initializationData,
            messageKey: FailureMessageKey.network);
      case ServerFailure:
        return InitializationRecoverableError(
            initializationData: state.initializationData,
            messageKey: FailureMessageKey.server);
      case CacheFailure:
        return InitializationUnrecoverableError(
            messageKey: FailureMessageKey.cache);
      case LoginFailure:
        return InitializationUnrecoverableError(
            messageKey: FailureMessageKey.login);
      case AuthenticationFailure:
        return InitializationUnrecoverableError(
            messageKey: FailureMessageKey.authentication);
      default:
        return InitializationUnrecoverableError(
            messageKey: FailureMessageKey.unexpected);
    }
  }
}
