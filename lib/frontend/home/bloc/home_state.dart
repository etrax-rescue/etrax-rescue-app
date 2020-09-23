part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  ready,
  closed,
}

class HomeState extends Equatable {
  const HomeState({
    @required this.status,
    @required this.appConnection,
    @required this.authenticationData,
    @required this.appConfiguration,
    @required this.missionState,
    @required this.missionDetailCollection,
    @required this.locationHistory,
    this.renewStatus = false,
  });

  final HomeStatus status;
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final AppConfiguration appConfiguration;
  final List<LocationData> locationHistory;
  final MissionState missionState;
  final MissionDetailCollection missionDetailCollection;
  final bool renewStatus;

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
          appConnection: null,
          authenticationData: null,
          appConfiguration: null,
          missionState: null,
          missionDetailCollection: null,
          locationHistory: const [],
        );

  const HomeState.closed()
      : this(
          status: HomeStatus.closed,
          appConnection: null,
          authenticationData: null,
          appConfiguration: null,
          missionState: null,
          missionDetailCollection: null,
          locationHistory: const [],
        );

  HomeState copyWith({
    HomeStatus status,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    AppConfiguration appConfiguration,
    MissionState missionState,
    MissionDetailCollection missionDetailCollection,
    List<LocationData> locationHistory,
    bool renewStatus,
  }) {
    return HomeState(
      status: status ?? this.status,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      appConfiguration: appConfiguration ?? this.appConfiguration,
      missionState: missionState ?? this.missionState,
      locationHistory: locationHistory ?? this.locationHistory,
      missionDetailCollection:
          missionDetailCollection ?? this.missionDetailCollection,
      renewStatus: renewStatus ?? false,
    );
  }

  @override
  List<Object> get props => [
        status,
        appConnection,
        authenticationData,
        appConfiguration,
        locationHistory,
        missionState,
        missionDetailCollection,
        renewStatus,
      ];
}
