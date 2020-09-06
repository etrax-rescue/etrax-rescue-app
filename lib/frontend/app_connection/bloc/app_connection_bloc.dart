import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/usecases/scan_qr_code.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/etrax_server_endpoints.dart';
import '../../../backend/usecases/set_app_connection.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';
import '../../util/uri_input_converter.dart';

part 'app_connection_event.dart';
part 'app_connection_state.dart';

class AppConnectionBloc extends Bloc<AppConnectionEvent, AppConnectionState> {
  AppConnectionBloc({
    @required this.setAppConnection,
    @required this.inputConverter,
  })  : assert(setAppConnection != null),
        assert(inputConverter != null),
        super(AppConnectionInitial());

  final SetAppConnection setAppConnection;
  final UriInputConverter inputConverter;

  @override
  Stream<AppConnectionState> mapEventToState(
    AppConnectionEvent event,
  ) async* {
    if (event is SubmitAppConnection) {
      final inputEither = inputConverter.convert(event.authority);

      yield* inputEither.fold((failure) async* {
        yield AppConnectionStateError(
            messageKey: INVALID_INPUT_FAILURE_MESSAGE_KEY);
      }, (authority) async* {
        yield AppConnectionStateInProgress();

        final failureOrOk = await setAppConnection(AppConnectionParams(
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
