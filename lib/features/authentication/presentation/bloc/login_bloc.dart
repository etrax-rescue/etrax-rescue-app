import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/mark_app_connection_for_update.dart';
import 'package:etrax_rescue_app/features/authentication/data/models/organizations_model.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/get_organizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/types/usecase.dart';
import '../../../../core/util/translate_error_messages.dart';
import '../../../app_connection/domain/usecases/get_app_connection.dart';
import '../../domain/usecases/login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final GetAppConnection getAppConnection;
  final GetOrganizations getOrganizations;
  final MarkAppConnectionForUpdate markAppConnectionForUpdate;
  LoginBloc(
      {@required this.login,
      @required this.getAppConnection,
      @required this.getOrganizations,
      @required this.markAppConnectionForUpdate})
      : assert(login != null),
        assert(getAppConnection != null),
        assert(getOrganizations != null),
        assert(markAppConnectionForUpdate != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is InitializeLogin) {
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield LoginError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final organizationsEither = await getOrganizations(
            GetOrganizationsParams(appConnection: appConnection));

        yield* organizationsEither.fold((failure) async* {},
            (organizations) async* {
          yield LoginReady(organizationCollection: organizations);
        });
      });
    } else if (event is SubmitLogin) {
      yield LoginInProgress();
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield LoginError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final loginEither = await login(LoginParams(
          appConnection: appConnection,
          username: event.username,
          password: event.password,
        ));
        yield* loginEither.fold((failure) async* {
          yield LoginError(messageKey: _mapFailureToMessage(failure));
        }, (_) async* {
          yield LoginSuccess();
        });
      });
    } else if (event is RequestAppConnectionUpdate) {
      final markEither = await markAppConnectionForUpdate(NoParams());
      yield* markEither.fold((failure) async* {
        yield LoginError(messageKey: _mapFailureToMessage(failure));
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
