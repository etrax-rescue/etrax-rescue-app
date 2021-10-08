// @dart=2.9
part of 'missions_bloc.dart';

enum InitializationStatus {
  inProgress,
  success,
  failure,
  unrecoverableFailure,
  logout,
}

class InitializationState extends Equatable {
  const InitializationState({
    @required this.status,
    this.initializationData,
    this.appConnection,
    this.authenticationData,
    this.messageKey,
  });

  final InitializationStatus status;

  final AppConnection appConnection;
  final AuthenticationData authenticationData;

  final InitializationData initializationData;

  final FailureMessageKey messageKey;

  const InitializationState.initial()
      : this(status: InitializationStatus.inProgress);

  InitializationState copyWith({
    @required InitializationStatus status,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    InitializationData initializationData,
    bool logout,
    FailureMessageKey messageKey,
    bool unrecoverable,
  }) {
    return InitializationState(
      status: status,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      initializationData: initializationData ?? this.initializationData,
      messageKey: messageKey,
    );
  }

  @override
  String toString() {
    return 'Status: $status; appConnection: $appConnection; authenticationData: $authenticationData; initializationData: $initializationData; messageKey: $messageKey';
  }

  @override
  List<Object> get props => [
        status,
        appConnection,
        authenticationData,
        initializationData,
        messageKey,
      ];
}
