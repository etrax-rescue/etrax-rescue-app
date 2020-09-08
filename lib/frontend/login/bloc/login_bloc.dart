import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/usecases/get_authentication_data.dart';
import 'package:flutter/material.dart';

import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_organizations.dart';
import '../../../backend/usecases/login.dart';
import '../../../backend/usecases/delete_app_connection.dart';
import '../../../backend/types/organizations.dart';
import '../../../core/error/failures.dart';
import '../../../backend/types/usecase.dart';
import '../../util/translate_error_messages.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final GetAppConnection getAppConnection;
  final GetOrganizations getOrganizations;
  final GetAuthenticationData getAuthenticationData;
  final DeleteAppConnection deleteAppConnection;

  LoginBloc({
    @required this.login,
    @required this.getAppConnection,
    @required this.getOrganizations,
    @required this.getAuthenticationData,
    @required this.deleteAppConnection,
  })  : assert(login != null),
        assert(getAppConnection != null),
        assert(getOrganizations != null),
        assert(deleteAppConnection != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is InitializeLogin) {
      final appConnectionEither = await getAppConnection(NoParams());
      yield* appConnectionEither.fold((failure) async* {
        yield OpenAppConnectionPage();
      }, (appConnection) async* {
        final organizationsEither = await getOrganizations(
            GetOrganizationsParams(appConnection: appConnection));

        yield* organizationsEither.fold((failure) async* {
          yield LoginInitializationError(
              messageKey: _mapFailureToMessage(failure));
        }, (organizations) async* {
          final authenticationDataEither =
              await getAuthenticationData(NoParams());

          yield* authenticationDataEither.fold((failure) async* {
            yield LoginReady(
                organizations: organizations,
                username: null,
                organizationID: null);
          }, (authenticationData) async* {
            yield LoginReady(
                organizations: organizations,
                username: authenticationData.username,
                organizationID: authenticationData.organizationID);
          });
        });
      });
    }
    if (event is SubmitLogin) {
      yield LoginInProgress(
        organizations: state.organizations,
        username: event.username,
        organizationID: event.organizationID,
      );
      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield LoginError(
            organizations: state.organizations,
            username: state.username,
            organizationID: state.organizationID,
            messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (appConnection) async* {
        final loginEither = await login(LoginParams(
          appConnection: appConnection,
          organizationID: event.organizationID,
          username: event.username,
          password: event.password,
        ));
        yield* loginEither.fold((failure) async* {
          yield LoginError(
              organizations: state.organizations,
              username: state.username,
              organizationID: state.organizationID,
              messageKey: _mapFailureToMessage(failure));
        }, (_) async* {
          yield LoginSuccess();
        });
      });
    } else if (event is RequestAppConnectionUpdate) {
      final markEither = await deleteAppConnection(NoParams());
      yield* markEither.fold((failure) async* {
        yield LoginError(
            organizations: state.organizations,
            username: state.username,
            organizationID: state.organizationID,
            messageKey: _mapFailureToMessage(failure));
      }, (_) async* {
        yield OpenAppConnectionPage();
      });
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
}
