import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/common/appconnect/domain/usecases/get_base_uri.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/messages/messages.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:flutter/material.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Login login;
  final GetBaseUri getBaseUri;
  AuthenticationBloc({@required this.login, @required this.getBaseUri})
      : assert(login != null),
        assert(getBaseUri != null),
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is SubmitLogin) {
      yield AuthenticationVerifying();
      final baseUriEither = await getBaseUri(NoParams());

      yield* baseUriEither.fold((failure) async* {
        yield AuthenticationError(message: CACHE_FAILURE_MESSAGE);
      }, (baseUri) async* {
        final authenticationEither = await login(LoginParams(
          baseUri: baseUri.baseUri,
          username: event.username,
          password: event.password,
        ));
        yield* authenticationEither.fold((failure) async* {
          yield AuthenticationError(message: _mapFailureToMessage(failure));
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
      return NETWORK_FAILURE_MESSAGE;
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    case LoginFailure:
      return LOGIN_FAILURE_MESSAGE;
    default:
      return UNEXPECTED_FAILURE_MESSAGE;
  }
}
