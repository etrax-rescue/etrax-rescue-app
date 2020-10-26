import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/backend/types/organizations.dart';
import 'package:etrax_rescue_app/backend/usecases/get_organizations.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/initialization_data.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/fetch_initialization_data.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/logout.dart';
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
        super(InitializationState.initial());

  final FetchInitializationData fetchInitializationData;
  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final Logout logout;

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is StartFetchingInitializationData) {
      yield state.copyWith(status: InitializationStatus.inProgress);

      final appConnectionEither = await getAppConnection(NoParams());

      yield* appConnectionEither.fold((failure) async* {
        yield state.copyWith(
            status: InitializationStatus.unrecoverableFailure,
            messageKey: mapFailureToMessageKey(failure));
      }, (appConnection) async* {
        final authenticationDataEither =
            await getAuthenticationData(NoParams());

        yield* authenticationDataEither.fold((failure) async* {
          print("failure while getting auth data");
          yield state.copyWith(
              status: InitializationStatus.unrecoverableFailure,
              messageKey: mapFailureToMessageKey(failure));
        }, (authenticationData) async* {
          print(authenticationData);
          yield state.copyWith(
              status: InitializationStatus.inProgress,
              appConnection: appConnection,
              authenticationData: authenticationData);

          final initializationEither = await fetchInitializationData(
              FetchInitializationDataParams(
                  appConnection: appConnection,
                  authenticationData: authenticationData));

          yield* initializationEither.fold((failure) async* {
            yield _mapFailureToErrorState(failure);
          }, (initializationData) async* {
            yield state.copyWith(
                status: InitializationStatus.success,
                initializationData: initializationData);
          });
        });
      });
    } else if (event is LogoutEvent) {
      final logoutEither = await logout(NoParams());

      yield* logoutEither.fold((failure) async* {
        yield _mapFailureToErrorState(failure);
      }, (initializationData) async* {
        yield state.copyWith(status: InitializationStatus.logout);
      });
    }
  }

  //! TODO: Update to mapFailureToMessageKey
  InitializationState _mapFailureToErrorState(Failure failure) {
    InitializationStatus status;
    FailureMessageKey messageKey = mapFailureToMessageKey(failure);

    switch (failure.runtimeType) {
      case NetworkFailure:
        status = InitializationStatus.failure;
        break;
      case ServerFailure:
        status = InitializationStatus.failure;
        break;
      case CacheFailure:
        status = InitializationStatus.unrecoverableFailure;
        break;
      case LoginFailure:
        status = InitializationStatus.unrecoverableFailure;
        break;
      case AuthenticationFailure:
        status = InitializationStatus.unrecoverableFailure;
        break;
      default:
        status = InitializationStatus.unrecoverableFailure;
        break;
    }
    return state.copyWith(status: status, messageKey: messageKey);
  }
}
