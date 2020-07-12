import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_connection/domain/usecases/get_app_connection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/login.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Login login;
  final GetAppConnection getAppConnection;
  AuthenticationBloc({@required this.login, @required this.getAppConnection})
      : assert(login != null),
        assert(getAppConnection != null),
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is SubmitLogin) {
      yield AuthenticationVerifying();
      final baseUriEither = await getAppConnection(NoParams());

      yield* baseUriEither.fold((failure) async* {
        yield AuthenticationError(message_key: CACHE_FAILURE_MESSAGE_KEY);
      }, (baseUri) async* {
        final authenticationEither = await login(LoginParams(
          baseUri: baseUri.baseUri,
          username: event.username,
          password: event.password,
        ));
        yield* authenticationEither.fold((failure) async* {
          yield AuthenticationError(message_key: _mapFailureToMessage(failure));
        }, (_) async* {
          yield AuthenticationSuccess();
        });
      });
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE_KEY;
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE_KEY;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE_KEY;
    case LoginFailure:
      return LOGIN_FAILURE_MESSAGE_KEY;
    default:
      return UNEXPECTED_FAILURE_MESSAGE_KEY;
  }
}
