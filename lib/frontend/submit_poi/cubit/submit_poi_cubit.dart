import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/types/poi.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/usecases/capture_poi.dart';
import 'package:etrax_rescue_app/backend/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/backend/usecases/get_authentication_data.dart';
import 'package:etrax_rescue_app/backend/usecases/send_poi.dart';
import 'package:flutter/material.dart';

part 'submit_poi_state.dart';

class SubmitPoiCubit extends Cubit<SubmitPoiState> {
  SubmitPoiCubit({
    @required this.getAppConnection,
    @required this.getAuthenticationData,
    @required this.capturePoi,
    @required this.sendPoi,
  })  : assert(getAppConnection != null),
        assert(getAuthenticationData != null),
        assert(capturePoi != null),
        assert(sendPoi != null),
        super(SubmitPoiState.initial());

  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final CapturePoi capturePoi;
  final SendPoi sendPoi;

  void capture() async {
    emit(state.copyWith(status: SubmitPoiStatus.captureInProgress));
    final capturePoiEither = await capturePoi(NoParams());

    await capturePoiEither.fold((failure) async {
      emit(state.copyWith(status: SubmitPoiStatus.captureFailure));
    }, (poi) async {
      emit(state.copyWith(
          status: SubmitPoiStatus.captureSuccess,
          imagePath: poi.imagePath,
          currentLocation: poi.locationData));
    });
  }

  void submit(String description) async {
    emit(state.copyWith(status: SubmitPoiStatus.submitInProgress));
    final getAppConnectionEither = await getAppConnection(NoParams());

    getAppConnectionEither.fold((failure) {
      // TODO: handle failure
    }, (appConnection) async {
      final getAuthenticationDataEither =
          await getAuthenticationData(NoParams());

      getAuthenticationDataEither.fold((failure) {
        // TODO: handle failure
      }, (authenticationData) async {
        final poi = Poi(
            locationData: state.currentLocation,
            imagePath: state.imagePath,
            description: description);
        final sendPoiEither = await sendPoi(SendPoiParams(
            appConnection: appConnection,
            authenticationData: authenticationData,
            poi: poi));

        sendPoiEither.fold((failure) {
          // TODO: handle failure
        }, (progressStream) async {
          // TODO: subscribe to stream
          emit(state.copyWith(status: SubmitPoiStatus.submitSuccess));
        });
      });
    });
  }
}
