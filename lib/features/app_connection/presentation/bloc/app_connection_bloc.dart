import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_connection/domain/usecases/verify_and_store_app_connection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/util/uri_input_converter.dart';

part 'app_connection_event.dart';
part 'app_connection_state.dart';

class AppConnectionBloc extends Bloc<AppConnectionEvent, AppConnectionState> {
  final VerifyAndStoreAppConnection verifyAndStore;
  final UriInputConverter inputConverter;
  AppConnectionBloc({
    @required this.verifyAndStore,
    @required this.inputConverter,
  })  : assert(verifyAndStore != null),
        assert(inputConverter != null),
        super(AppConnectionInitial());

  @override
  Stream<AppConnectionState> mapEventToState(
    AppConnectionEvent event,
  ) async* {
    if (event is ConnectApp) {
      final inputEither = inputConverter.convert(event.uriString);

      yield* inputEither.fold((failure) async* {
        yield AppConnectionError(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (uri) async* {
        yield AppConnectionVerifying();
        final failureOrOk =
            await verifyAndStore(AppConnectionParams(baseUri: uri));

        yield failureOrOk.fold(
            (failure) =>
                AppConnectionError(message: _mapFailureToMessage(failure)),
            (ok) => AppConnectionSuccess());
      });
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE;
    case ServerFailure:
      return SERVER_URL_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return UNEXPECTED_FAILURE_MESSAGE;
  }
}
