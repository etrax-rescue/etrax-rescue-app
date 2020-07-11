import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_connect/domain/usecases/verify_and_store_base_uri.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/util/uri_input_converter.dart';

part 'app_connect_event.dart';
part 'app_connect_state.dart';

class AppConnectBloc extends Bloc<AppConnectEvent, AppConnectState> {
  final VerifyAndStoreBaseUri verifyAndStore;
  final UriInputConverter inputConverter;
  AppConnectBloc({
    @required this.verifyAndStore,
    @required this.inputConverter,
  })  : assert(verifyAndStore != null),
        assert(inputConverter != null),
        super(AppConnectInitial());

  @override
  Stream<AppConnectState> mapEventToState(
    AppConnectEvent event,
  ) async* {
    if (event is ConnectApp) {
      final inputEither = inputConverter.convert(event.uriString);

      yield* inputEither.fold((failure) async* {
        yield AppConnectError(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (uri) async* {
        yield AppConnectVerifying();
        final failureOrOk = await verifyAndStore(BaseUriParams(baseUri: uri));

        yield failureOrOk.fold(
            (failure) =>
                AppConnectError(message: _mapFailureToMessage(failure)),
            (ok) => AppConnectStored());
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
