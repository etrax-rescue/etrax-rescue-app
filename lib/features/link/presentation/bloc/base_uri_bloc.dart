import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../common/link/domain/usecases/verify_and_store_base_uri.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/util/uri_input_converter.dart';

part 'base_uri_event.dart';
part 'base_uri_state.dart';

class BaseUriBloc extends Bloc<BaseUriEvent, BaseUriState> {
  final VerifyAndStoreBaseUri verifyAndStore;
  final UriInputConverter inputConverter;
  BaseUriBloc({
    @required this.verifyAndStore,
    @required this.inputConverter,
  })  : assert(verifyAndStore != null),
        assert(inputConverter != null),
        super(BaseUriInitial());

  @override
  Stream<BaseUriState> mapEventToState(
    BaseUriEvent event,
  ) async* {
    if (event is StoreBaseUri) {
      final inputEither = inputConverter.convert(event.uriString);

      yield* inputEither.fold((failure) async* {
        yield BaseUriError(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (uri) async* {
        yield BaseUriVerifying();
        final failureOrOk = await verifyAndStore(BaseUriParams(baseUri: uri));

        yield failureOrOk.fold(
            (failure) => BaseUriError(message: _mapFailureToMessage(failure)),
            (ok) => BaseUriStored());
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
    default:
      return UNEXPECTED_FAILURE_MESSAGE;
  }
}
