// @dart=2.9
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/etrax_server_endpoints.dart';
import '../../../backend/usecases/scan_qr_code.dart';
import '../../../backend/usecases/set_app_connection.dart';
import '../../util/translate_error_messages.dart';
import '../../util/uri_input_converter.dart';

part 'app_connection_state.dart';

class AppConnectionCubit extends Cubit<AppConnectionState> {
  AppConnectionCubit({
    @required this.scanQrCode,
    @required this.setAppConnection,
    @required this.inputConverter,
  })  : assert(scanQrCode != null),
        assert(setAppConnection != null),
        assert(inputConverter != null),
        super(AppConnectionState.initial());

  final ScanQrCode scanQrCode;
  final SetAppConnection setAppConnection;
  final UriInputConverter inputConverter;

  void scanCode(
    String cancelText,
    String flashOnText,
    String flashOffText,
  ) async {
    emit(state.copyWith(status: AppConnectionStatus.loading));

    final scanQrCodeEither = await scanQrCode(ScanQrCodeParams(
      cancelText: cancelText,
      flashOnText: flashOnText,
      flashOffText: flashOffText,
    ));

    await scanQrCodeEither.fold((failure) async {
      emit(state.copyWith(
          status: AppConnectionStatus.error,
          messageKey: mapFailureToMessageKey(failure)));
    }, (connectionString) async {
      emit(state.copyWith(
        status: AppConnectionStatus.ready,
        connectionString: connectionString,
      ));
    });
  }

  void submit(String connectionString) async {
    final inputEither = inputConverter.convert(connectionString);

    inputEither.fold((failure) {
      emit(state.copyWith(
          status: AppConnectionStatus.error,
          messageKey: mapFailureToMessageKey(failure)));
    }, (connectionString) async {
      emit(state.copyWith(
        status: AppConnectionStatus.loading,
        connectionString: connectionString,
      ));

      final setAppConnectionEither = await setAppConnection(AppConnectionParams(
          authority: connectionString, basePath: SERVER_API_BASE_PATH));

      setAppConnectionEither.fold((failure) {
        emit(state.copyWith(
            status: AppConnectionStatus.error,
            messageKey: mapFailureToMessageKey(failure)));
      }, (_) {
        emit(AppConnectionState.success());
      });
    });
  }
}
