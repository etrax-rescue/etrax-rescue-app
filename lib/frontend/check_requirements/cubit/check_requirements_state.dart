part of 'check_requirements_cubit.dart';

enum CheckRequirementsStatus {
  initial,

  started,

  settingsLoading,
  settingsFailure,
  settingsSuccess,

  locationPermissionLoading,
  locationPermissionDenied,
  locationPermissionDeniedForever,
  locationPermissionFailure,
  locationPermissionSuccess,

  locationServicesLoading,
  locationServicesDisabled,
  locationServicesFailure,
  locationServicesSuccess,

  getLastLocationLoading,
  getLastLocationFailure,
  getLastLocationSuccess,

  setStateLoading,
  setStateFailure,
  setStateSuccess,

  logoutLoading,
  logoutFailure,
  logoutSuccess,

  stopUpdatesLoading,
  stopUpdatesFailure,
  stopUpdatesSuccess,

  startUpdatesLoading,
  startUpdatesFailure,
  startUpdatesSuccess,

  clearStateLoading,
  clearStateFailure,
  clearStateSuccess,

  success,
  logout,
}

extension CheckRequirementsStatusExtension on CheckRequirementsStatus {
  bool operator <(CheckRequirementsStatus other) {
    return this.index < other.index;
  }

  bool operator >=(CheckRequirementsStatus other) {
    return this.index >= other.index;
  }
}

class CheckRequirementsState extends Equatable {
  const CheckRequirementsState({
    this.status = CheckRequirementsStatus.initial,
    this.messageKey = '',
    @required this.userState,
    @required this.appConfiguration,
    @required this.appConnection,
    @required this.authenticationData,
    @required this.currentLocation,
    @required this.notificationTitle,
    @required this.notificationBody,
    @required this.label,
  });

  final CheckRequirementsStatus status;

  final String messageKey;

  final UserState userState;

  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final AppConfiguration appConfiguration;

  final LocationData currentLocation;

  final String notificationTitle;
  final String notificationBody;
  final String label;

  @override
  List<Object> get props => [status.index];

  const CheckRequirementsState.initial()
      : this(
          userState: null,
          appConfiguration: null,
          appConnection: null,
          authenticationData: null,
          currentLocation: null,
          notificationTitle: '',
          notificationBody: '',
          label: '',
        );

  CheckRequirementsState copyWith({
    @required CheckRequirementsStatus status,
    String messageKey = '',
    UserState userState,
    AppConfiguration appConfiguration,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    LocationData currentLocation,
    String notificationTitle,
    String notificationBody,
    String label,
  }) {
    return CheckRequirementsState(
      status: status ?? this.status,
      messageKey: messageKey ?? '',
      userState: userState ?? this.userState,
      appConfiguration: appConfiguration ?? this.appConfiguration,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      currentLocation: currentLocation ?? this.currentLocation,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationBody: notificationBody ?? this.notificationBody,
      label: label ?? this.label,
    );
  }
}
