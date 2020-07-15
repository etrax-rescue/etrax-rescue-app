import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:flutter/material.dart';

import '../../../../core/types/usecase.dart';
import '../../../app_connection/domain/usecases/get_app_connection.dart';
import '../../../authentication/domain/usecases/get_authentication_data.dart';
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
      yield InitializationFetching();

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield InitializationError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          yield InitializationError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
        }, (authenticationData) async* {
          final initializationEither = await fetchInitializationData(
              FetchInitializationDataParams(
                  appConnection: appConnection,
                  username: authenticationData.username,
                  token: authenticationData.token));

          yield* initializationEither.fold((failure) async* {
            yield InitializationError(
                messageKey: _mapFailureToMessageKey(failure));
          }, (_) async* {
            yield InitializationFetched();
          });
        });
      });
    }
  }
}

String _mapFailureToMessageKey(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE_KEY;
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE_KEY;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE_KEY;
    case LoginFailure:
      return LOGIN_FAILURE_MESSAGE_KEY;
    case AuthenticationFailure:
      return AUTHENTICATION_FAILURE_MESSAGE_KEY;
    default:
      return UNEXPECTED_FAILURE_MESSAGE_KEY;
  }
}
