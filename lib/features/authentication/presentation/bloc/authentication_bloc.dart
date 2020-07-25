import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/mark_app_connection_for_update.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../../../../core/util/translate_error_messages.dart';
import '../../../app_connection/domain/usecases/get_app_connection.dart';
import '../../domain/usecases/login.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Login login;
  final GetAppConnection getAppConnection;
  final MarkAppConnectionForUpdate markAppConnectionForUpdate;
  AuthenticationBloc(
      {@required this.login,
      @required this.getAppConnection,
      @required this.markAppConnectionForUpdate})
      : assert(login != null),
        assert(getAppConnection != null),
        assert(markAppConnectionForUpdate != null),
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is SubmitLogin) {
      yield AuthenticationVerifying();
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield AuthenticationError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final authenticationEither = await login(LoginParams(
          appConnection: appConnection,
          username: event.username,
          password: event.password,
        ));
        yield* authenticationEither.fold((failure) async* {
          yield AuthenticationError(messageKey: _mapFailureToMessage(failure));
        }, (_) async* {
          yield AuthenticationSuccess();
        });
      });
    } else if (event is RequestAppConnectionUpdate) {
      final markEither = await markAppConnectionForUpdate(NoParams());
      yield* markEither.fold((failure) async* {
        yield AuthenticationError(messageKey: _mapFailureToMessage(failure));
      }, (_) async* {
        yield RequestedAppConnectionUpdate();
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
