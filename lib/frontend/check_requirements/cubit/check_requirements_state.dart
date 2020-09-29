part of 'check_requirements_cubit.dart';

enum StepStatus {
  disabled,
  loading,
  failure,
  complete,
}

class CheckRequirementsState extends Equatable {
  const CheckRequirementsState({
    @required this.currentIndex,
    @required this.currentStep,
    @required this.sequence,
    @required this.sequenceStatus,
    @required this.currentState,
    @required this.desiredState,
    @required this.quickAction,
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

  final SequenceStep currentStep;
  final int currentIndex;

  final UserState currentState;
  final UserState desiredState;
  final QuickAction quickAction;

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
          currentStep: null,
          currentIndex: -1,
          currentState: null,
          desiredState: null,
          quickAction: null,
          appConfiguration: null,
          appConnection: null,
          authenticationData: null,
        );

  CheckRequirementsState markComplete() {
    return CheckRequirementsState(
      sequence: this.sequence,
      sequenceStatus: this.sequenceStatus,
      currentIndex: this.currentIndex,
      currentStep: this.currentStep,
      currentState: this.currentState,
      desiredState: this.desiredState,
      quickAction: this.quickAction,
      appConfiguration: this.appConfiguration,
      appConnection: this.appConnection,
      authenticationData: this.authenticationData,
      complete: true,
    );
  }

  CheckRequirementsState copyWith({
    List<SequenceStep> sequence,
    List<StepStatus> sequenceStatus,
    SequenceStep currentStep,
    int currentIndex,
    FailureMessageKey messageKey,
    UserState currentState,
    UserState desiredState,
    QuickAction quickAction,
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
      currentStep: currentStep ?? this.currentStep,
      currentIndex: currentIndex ?? this.currentIndex,
      messageKey: messageKey ?? FailureMessageKey.unexpected,
      currentState: currentState ?? this.currentState,
      desiredState: desiredState ?? this.desiredState,
      quickAction: quickAction ?? this.quickAction,
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
        currentIndex,
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
