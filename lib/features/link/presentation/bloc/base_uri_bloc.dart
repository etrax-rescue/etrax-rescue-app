import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/core/util/uri_input_converter.dart';
import 'package:etrax_rescue_app/features/link/domain/usecases/verify_and_store_base_uri.dart';
import 'package:flutter/material.dart';

part 'base_uri_event.dart';
part 'base_uri_state.dart';

class BaseUriBloc extends Bloc<BaseUriEvent, BaseUriState> {
  final VerifyAndStoreBaseUri store;
  final UriInputConverter inputConverter;
  BaseUriBloc({
    @required this.store,
    @required this.inputConverter,
  })  : assert(store != null),
        assert(inputConverter != null),
        super(BaseUriInitial());

  @override
  Stream<BaseUriState> mapEventToState(
    BaseUriEvent event,
  ) async* {
    if (event is StoreBaseUri) {
      final inputEither = inputConverter.convert(event.uriString);

      yield* inputEither.fold((failure) async* {
        yield BaseUriError(message: null);
      }, (uri) async* {
        store(baseUri: uri);
      });
    }
  }
}
