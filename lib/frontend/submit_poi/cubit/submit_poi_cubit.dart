import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/usecases/take_photo.dart';
import 'package:flutter/material.dart';

part 'submit_poi_state.dart';

class SubmitPoiCubit extends Cubit<SubmitPoiState> {
  SubmitPoiCubit({
    @required this.takePhoto,
  })  : assert(takePhoto != null),
        super(SubmitPoiState.initial());

  final TakePhoto takePhoto;

  void capture() async {
    emit(state.copyWith(status: SubmitPoiStatus.captureInProgress));
    final takePhotoEither = await takePhoto(NoParams());

    await takePhotoEither.fold((failure) async {
      emit(state.copyWith(status: SubmitPoiStatus.captureFailure));
    }, (imagePath) async {
      emit(state.copyWith(
          status: SubmitPoiStatus.captureSuccess, imagePath: imagePath));
    });
  }

  void submit() async {
    emit(state.copyWith(status: SubmitPoiStatus.submitInProgress));
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: SubmitPoiStatus.submitSuccess));
  }
}
