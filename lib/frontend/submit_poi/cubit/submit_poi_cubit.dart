import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../backend/types/poi.dart';
import '../../../backend/types/usecase.dart';
import '../../../backend/usecases/capture_poi.dart';
import '../../../backend/usecases/get_app_connection.dart';
import '../../../backend/usecases/get_authentication_data.dart';
import '../../../backend/usecases/send_poi.dart';
import '../../../core/error/failures.dart';
import '../../util/translate_error_messages.dart';

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
        super(SubmitPoiInitial());

  final GetAppConnection getAppConnection;
  final GetAuthenticationData getAuthenticationData;
  final CapturePoi capturePoi;
  final SendPoi sendPoi;

  StreamSubscription<double> _streamSubscription;

  void capture() async {
    emit(SubmitPoiLoading());
    final capturePoiEither = await capturePoi(NoParams());

    await capturePoiEither.fold((failure) async {
      emit(SubmitPoiCaptureFailure());
    }, (poi) async {
      emit(SubmitPoiReady(
          imagePath: poi.imagePath, currentLocation: poi.locationData));
    });
  }

  void submit(String description) async {
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
          emit(SubmitPoiError(
              imagePath: state.imagePath,
              currentLocation: state.currentLocation,
              messageKey: _mapFailureToMessage(failure)));
        }, (progressStream) async {
          // TODO: subscribe to stream
          await _streamSubscription?.cancel();
          emit(SubmitPoiUploading(
              imagePath: state.imagePath,
              currentLocation: state.currentLocation,
              progress: 0.0));
          _streamSubscription = progressStream
              .listen((double progress) => progressUpdate(progress),
                  onError: (failure) {
            if (failure is Failure) {
              emit(SubmitPoiError(
                  imagePath: state.imagePath,
                  currentLocation: state.currentLocation,
                  messageKey: _mapFailureToMessage(failure)));
            } else {
              emit(SubmitPoiError(
                  imagePath: state.imagePath,
                  currentLocation: state.currentLocation,
                  messageKey: FailureMessageKey.unexpected));
            }
          });
        });
      });
    });
  }

  void progressUpdate(progress) {
    if (progress < 1.0) {
      emit(SubmitPoiUploading(
          imagePath: state.imagePath,
          currentLocation: state.currentLocation,
          progress: progress));
    } else {
      emit(SubmitPoiSuccess(
          imagePath: state.imagePath, currentLocation: state.currentLocation));
    }
  }

  FailureMessageKey _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return FailureMessageKey.network;
      case ServerFailure:
        return FailureMessageKey.server;
      case CacheFailure:
        return FailureMessageKey.cache;
      default:
        return FailureMessageKey.unexpected;
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
