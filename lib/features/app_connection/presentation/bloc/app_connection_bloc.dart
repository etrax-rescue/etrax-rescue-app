import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/get_app_connection_marked_for_update.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/util/translate_error_messages.dart';
import '../../../../core/util/uri_input_converter.dart';
import '../../../app_connection/domain/usecases/verify_and_store_app_connection.dart';

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
    if (event is CheckUpdateStatus) {
      final appConnectionStatusEither = await markedForUpdate(NoParams());

      yield* appConnectionStatusEither.fold((failure) async* {
        yield AppConnectionError(messageKey: CACHE_FAILURE_MESSAGE_KEY);
      }, (updateRequired) async* {
        if (updateRequired) {
          yield AppConnectionReady();
        } else {
          yield AppConnectionSuccess();
        }
      });
    } else if (event is ConnectApp) {
      final inputEither = inputConverter.convert(event.authority);

      yield* inputEither.fold((failure) async* {
        yield AppConnectionError(messageKey: INVALID_INPUT_FAILURE_MESSAGE_KEY);
      }, (authority) async* {
        yield AppConnectionVerifying();

        final failureOrOk = await verifyAndStore(AppConnectionParams(
            authority: authority, basePath: SERVER_API_BASE_PATH));

        yield failureOrOk.fold(
            (failure) =>
                AppConnectionError(messageKey: _mapFailureToMessage(failure)),
            (ok) => AppConnectionSuccess());
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
