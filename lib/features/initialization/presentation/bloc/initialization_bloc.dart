import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../../../../core/util/translate_error_messages.dart';
import '../../../app_connection/domain/usecases/get_app_connection.dart';
import '../../../authentication/domain/usecases/get_authentication_data.dart';
import '../../domain/entities/initialization_data.dart';
import '../../domain/usecases/fetch_initialization_data.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  final FetchInitializationData fetchInitializationData;
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  InitializationBloc(
      {@required this.fetchInitializationData,
      @required this.getAppConnection,
      @required this.getAuthenticationData})
      : assert(fetchInitializationData != null),
        assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        super(InitializationInitial());

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is StartFetchingInitializationData) {
      yield InitializationInProgress();

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield InitializationUnrecoverableError(
            messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          yield InitializationUnrecoverableError(
              messageKey: CACHE_FAILURE_MESSAGE_KEY);
        }, (authenticationData) async* {
          final initializationEither = await fetchInitializationData(
              FetchInitializationDataParams(
                  appConnection: appConnection,
                  authenticationData: authenticationData));

          yield* initializationEither.fold((failure) async* {
            yield _mapFailureToErrorState(failure);
          }, (initializationData) async* {
            yield InitializationSuccess(initializationData);
          });
        });
      });
    }
  }
}

InitializationState _mapFailureToErrorState(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return InitializationRecoverableError(
          messageKey: NETWORK_FAILURE_MESSAGE_KEY);
    case ServerFailure:
      return InitializationRecoverableError(
          messageKey: SERVER_FAILURE_MESSAGE_KEY);
    case CacheFailure:
      return InitializationUnrecoverableError(
          messageKey: CACHE_FAILURE_MESSAGE_KEY);
    case LoginFailure:
      return InitializationUnrecoverableError(
          messageKey: LOGIN_FAILURE_MESSAGE_KEY);
    case AuthenticationFailure:
      return InitializationUnrecoverableError(
          messageKey: AUTHENTICATION_FAILURE_MESSAGE_KEY);
    default:
      return InitializationUnrecoverableError(
          messageKey: UNEXPECTED_FAILURE_MESSAGE_KEY);
  }
}
