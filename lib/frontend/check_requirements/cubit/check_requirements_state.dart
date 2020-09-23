part of 'check_requirements_cubit.dart';

enum CheckRequirementsStatus {
  initial,
  started,
  settings,
  locationPermission,
  locationServices,
  getLastLocation,
  setState,
  logout,
  stopUpdates,
  startUpdates,
  clearState,
  complete,
}

enum CheckRequirementsSubStatus {
  loading,
  failure,
  result1,
  result2,
  success,
}

extension CheckRequirementsStatusExtension on CheckRequirementsStatus {
  bool operator <(CheckRequirementsStatus other) {
    return this.index < other.index;
  }

  bool operator >(CheckRequirementsStatus other) {
    return this.index > other.index;
  }

  bool operator >=(CheckRequirementsStatus other) {
    return this.index >= other.index;
  }
}

class CheckRequirementsState extends Equatable {
  const CheckRequirementsState({
    this.currentStep = 0,
    this.sequence = const [],
    this.status = CheckRequirementsStatus.initial,
    this.subStatus = CheckRequirementsSubStatus.loading,
    this.messageKey,
    @required this.currentState,
    @required this.desiredState,
    @required this.appConfiguration,
    @required this.appConnection,
    @required this.authenticationData,
    @required this.notificationTitle,
    @required this.notificationBody,
    @required this.label,
  });

  final List<SequenceStep> sequence;
  final int currentStep;

  final CheckRequirementsStatus status;
  final CheckRequirementsSubStatus subStatus;

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
          currentStep: null,
          currentState: null,
          desiredState: null,
          appConfiguration: null,
          appConnection: null,
          authenticationData: null,
          notificationTitle: '',
          notificationBody: '',
          label: '',
        );

  CheckRequirementsState copyWith({
    List<SequenceStep> sequence,
    int currentStep,
    @required CheckRequirementsStatus status,
    @required CheckRequirementsSubStatus subStatus,
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
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      subStatus: subStatus ?? this.subStatus,
      messageKey: messageKey,
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

  @override
  List<Object> get props => [
        status,
        subStatus,
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
