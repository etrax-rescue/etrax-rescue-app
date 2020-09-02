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
    @required this.missionState,
    @required this.missionDetailCollection,
    @required this.locationHistory,
  });

  final HomeStatus status;
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final List<LocationData> locationHistory;
  final MissionState missionState;
  final MissionDetailCollection missionDetailCollection;

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
          appConnection: null,
          authenticationData: null,
          missionState: null,
          missionDetailCollection: null,
          locationHistory: const [],
        );

  const HomeState.closed()
      : this(
          status: HomeStatus.closed,
          appConnection: null,
          authenticationData: null,
          missionState: null,
          missionDetailCollection: null,
          locationHistory: const [],
        );

  HomeState copyWith({
    HomeStatus status,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    MissionState missionState,
    MissionDetailCollection missionDetailCollection,
    List<LocationData> locationHistory,
  }) {
    return HomeState(
      status: status ?? this.status,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      missionState: missionState ?? this.missionState,
      locationHistory: locationHistory ?? this.locationHistory,
      missionDetailCollection:
          missionDetailCollection ?? this.missionDetailCollection,
    );
  }

  @override
  List<Object> get props => [
        status,
        appConnection,
        authenticationData,
        locationHistory,
        missionState
      ];
}
