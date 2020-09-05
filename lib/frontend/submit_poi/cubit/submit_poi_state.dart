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
    @required this.messageKey,
  });

  final SubmitPoiStatus status;
  final String imagePath;
  final String messageKey;

  const SubmitPoiState.initial()
      : this(status: SubmitPoiStatus.initial, imagePath: '', messageKey: '');

  @override
  List<Object> get props => [status, imagePath, messageKey];

  SubmitPoiState copyWith({
    SubmitPoiStatus status,
    String imagePath,
    String messageKey,
  }) {
    return SubmitPoiState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      messageKey: messageKey,
    );
  }
}
