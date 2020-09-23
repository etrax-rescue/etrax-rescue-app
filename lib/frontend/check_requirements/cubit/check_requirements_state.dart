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
    this.messageKey = FailureMessageKey.unexpected,
    this.notificationTitle = '',
    this.notificationBody = '',
    this.label = '',
  });

  final List<SequenceStep> sequence;
  final List<StepStatus> sequenceStatus;

  final int currentStepIndex;

  final FailureMessageKey messageKey;

  final UserState currentState;
  final UserState desiredState;

  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final AppConfiguration appConfiguration;

  final String notificationTitle;
  final String notificationBody;
  final String label;

  const CheckRequirementsState.initial()
      : this(
          sequence: const [],
          sequenceStatus: const [],
          currentStepIndex: 0,
          currentState: null,
          desiredState: null,
          appConfiguration: null,
          appConnection: null,
          authenticationData: null,
        );

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
      messageKey: messageKey ?? this.messageKey,
      currentState: currentState ?? this.currentState,
      desiredState: desiredState ?? this.desiredState,
      appConfiguration: appConfiguration ?? this.appConfiguration,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationBody: notificationBody ?? this.notificationBody,
      label: label ?? this.label,
    );
  }

  // currentStep is intentionally left out, so that increasing the currentStep
  // without changing the sequence status does not trigger bloc state updates.
  @override
  List<Object> get props => [
        sequence,
        sequenceStatus,
        messageKey,
        currentState,
        desiredState,
        appConnection,
        authenticationData,
        appConfiguration,
        notificationTitle,
        notificationBody,
        label,
      ];
}
