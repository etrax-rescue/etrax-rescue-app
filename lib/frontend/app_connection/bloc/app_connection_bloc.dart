import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/domain/usecases/get_app_connection_marked_for_update.dart';
import '../../../backend/domain/usecases/verify_and_store_app_connection.dart';
import '../../../core/error/failures.dart';
import '../../../core/types/etrax_server_endpoints.dart';
import '../../../core/types/usecase.dart';
import '../../../core/util/translate_error_messages.dart';
import '../../../core/util/uri_input_converter.dart';

part 'app_connection_event.dart';
part 'app_connection_state.dart';

class AppConnectionBloc extends Bloc<AppConnectionEvent, AppConnectionState> {
  final GetAppConnectionMarkedForUpdate markedForUpdate;
  final VerifyAndStoreAppConnection verifyAndStore;
  final UriInputConverter inputConverter;
  AppConnectionBloc({
    @required this.markedForUpdate,
    @required this.verifyAndStore,
    @required this.inputConverter,
  })  : assert(markedForUpdate != null),
        assert(verifyAndStore != null),
        assert(inputConverter != null),
        super(AppConnectionInitial());

  @override
  Stream<AppConnectionState> mapEventToState(
    AppConnectionEvent event,
  ) async* {
    if (event is AppConnectionEventCheck) {
      final appConnectionStatusEither = await markedForUpdate(NoParams());

      yield* appConnectionStatusEither.fold((failure) async* {
        yield AppConnectionStateReady(); //AppConnectionStateError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (updateRequired) async* {
        if (updateRequired) {
          yield AppConnectionStateReady();
        } else {
          yield AppConnectionStateSuccess();
        }
      });
    } else if (event is AppConnectionEventConnect) {
      final inputEither = inputConverter.convert(event.authority);

      yield* inputEither.fold((failure) async* {
        yield AppConnectionStateError(
            messageKey: INVALID_INPUT_FAILURE_MESSAGE_KEY);
      }, (authority) async* {
        yield AppConnectionStateInProgress();

        final failureOrOk = await verifyAndStore(AppConnectionParams(
            authority: authority, basePath: SERVER_API_BASE_PATH));

        yield failureOrOk.fold(
            (failure) => AppConnectionStateError(
                messageKey: _mapFailureToMessage(failure)),
            (ok) => AppConnectionStateSuccess());
      });
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE_KEY;
    case ServerFailure:
      return SERVER_URL_FAILURE_MESSAGE_KEY;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE_KEY;
    default:
      return UNEXPECTED_FAILURE_MESSAGE_KEY;
  }
}
