part of 'check_requirements_cubit.dart';

enum StepStatus {
  disabled,
  loading,
  failure,
  complete,
}

class CheckRequirementsState extends Equatable {
  const CheckRequirementsState({
    @required this.currentStepIndex,
    @required this.sequence,
    @required this.sequenceStatus,
    @required this.currentState,
    @required this.desiredState,
    @required this.appConfiguration,
    @required this.appConnection,
    @required this.authenticationData,
    this.complete = false,
    this.messageKey = FailureMessageKey.unexpected,
    this.notificationTitle = '',
    this.notificationBody = '',
  });

  final List<SequenceStep> sequence;
  final List<StepStatus> sequenceStatus;

  final int currentStepIndex;

  final UserState currentState;
  final UserState desiredState;

  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final AppConfiguration appConfiguration;

  final bool complete;

  final FailureMessageKey messageKey;

  final String notificationTitle;
  final String notificationBody;

  const CheckRequirementsState.initial()
      : this(
          sequence: const [],
          sequenceStatus: const [],
          currentStepIndex: -1,
          currentState: null,
          desiredState: null,
          appConfiguration: null,
          appConnection: null,
          authenticationData: null,
        );

  CheckRequirementsState markComplete() {
    return CheckRequirementsState(
      sequence: this.sequence,
      sequenceStatus: this.sequenceStatus,
      currentStepIndex: this.currentStepIndex,
      currentState: this.currentState,
      desiredState: this.desiredState,
      appConfiguration: this.appConfiguration,
      appConnection: this.appConnection,
      authenticationData: this.authenticationData,
      complete: true,
    );
  }

  CheckRequirementsState copyWith({
    List<SequenceStep> sequence,
    List<StepStatus> sequenceStatus,
    int currentStepIndex,
    FailureMessageKey messageKey,
    UserState currentState,
    UserState desiredState,
    AppConfiguration appConfiguration,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    String notificationTitle,
    String notificationBody,
    String label,
  }) {
    return CheckRequirementsState(
      sequence: sequence ?? this.sequence,
      sequenceStatus: sequenceStatus ?? this.sequenceStatus,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      messageKey: messageKey ?? FailureMessageKey.unexpected,
      currentState: currentState ?? this.currentState,
      desiredState: desiredState ?? this.desiredState,
      appConfiguration: appConfiguration ?? this.appConfiguration,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationBody: notificationBody ?? this.notificationBody,
    );
  }

  @override
  List<Object> get props => [
        sequence,
        sequenceStatus,
        currentStepIndex,
        currentState,
        desiredState,
        appConnection,
        authenticationData,
        appConfiguration,
        complete,
        messageKey,
        notificationTitle,
        notificationBody,
      ];
}
