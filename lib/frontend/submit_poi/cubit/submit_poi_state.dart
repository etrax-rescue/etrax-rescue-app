part of 'submit_poi_cubit.dart';

enum SubmitPoiStatus {
  initial,
  captureInProgress,
  captureFailure,
  captureSuccess,
  submitInProgress,
  submitSuccess,
}

class SubmitPoiState extends Equatable {
  const SubmitPoiState({
    @required this.status,
    @required this.imagePath,
    @required this.currentLocation,
    @required this.messageKey,
  });

  final SubmitPoiStatus status;
  final String imagePath;
  final String messageKey;
  final LocationData currentLocation;

  const SubmitPoiState.initial()
      : this(
            status: SubmitPoiStatus.initial,
            imagePath: '',
            messageKey: '',
            currentLocation: null);

  @override
  List<Object> get props => [status, imagePath, currentLocation, messageKey];

  SubmitPoiState copyWith({
    SubmitPoiStatus status,
    String imagePath,
    LocationData currentLocation,
    String messageKey,
  }) {
    return SubmitPoiState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      currentLocation: currentLocation ?? this.currentLocation,
      messageKey: messageKey,
    );
  }
}
