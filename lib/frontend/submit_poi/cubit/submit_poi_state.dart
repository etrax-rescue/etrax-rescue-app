part of 'submit_poi_cubit.dart';

abstract class SubmitPoiState extends Equatable {
  const SubmitPoiState(
      {@required this.imagePath, @required this.currentLocation});

  final String imagePath;
  final LocationData currentLocation;

  @override
  List<Object> get props => [imagePath, currentLocation];
}

class SubmitPoiInitial extends SubmitPoiState {}

class SubmitPoiLoading extends SubmitPoiState {}

class SubmitPoiCaptureFailure extends SubmitPoiState {}

class SubmitPoiError extends SubmitPoiState {
  SubmitPoiError({
    @required String imagePath,
    @required LocationData currentLocation,
    @required this.messageKey,
  }) : super(imagePath: imagePath, currentLocation: currentLocation);

  final FailureMessageKey messageKey;

  @override
  List<Object> get props => [imagePath, currentLocation, messageKey];
}

class SubmitPoiReady extends SubmitPoiState {
  SubmitPoiReady(
      {@required String imagePath, @required LocationData currentLocation})
      : super(imagePath: imagePath, currentLocation: currentLocation);
}

class SubmitPoiUploading extends SubmitPoiState {
  SubmitPoiUploading(
      {@required String imagePath,
      @required LocationData currentLocation,
      @required this.progress})
      : super(imagePath: imagePath, currentLocation: currentLocation);

  final double progress;

  @override
  List<Object> get props => [imagePath, currentLocation, progress];
}

class SubmitPoiSuccess extends SubmitPoiState {
  SubmitPoiSuccess({
    @required String imagePath,
    @required LocationData currentLocation,
  }) : super(imagePath: imagePath, currentLocation: currentLocation);
}
