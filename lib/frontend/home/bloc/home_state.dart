// @dart=2.9
part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  ready,
}

class HomeState extends Equatable {
  const HomeState({
    @required this.status,
    @required this.appConnection,
    @required this.authenticationData,
    @required this.appConfiguration,
    @required this.quickActions,
    @required this.missionState,
    @required this.missionDetailCollection,
    @required this.searchAreaCollection,
    @required this.locationHistory,
    this.tokenExpired = false,
    this.renewStatus = false,
    this.lastupdate,
    this.messageKey,
  });

  final HomeStatus status;
  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final AppConfiguration appConfiguration;
  final QuickActionCollection quickActions;
  final List<LocationData> locationHistory;
  final MissionState missionState;
  final MissionDetailCollection missionDetailCollection;
  final SearchAreaCollection searchAreaCollection;
  final bool renewStatus;
  final DateTime lastupdate;
  final bool tokenExpired;
  final FailureMessageKey messageKey;

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
          appConnection: null,
          authenticationData: null,
          appConfiguration: null,
          quickActions: null,
          missionState: null,
          missionDetailCollection: null,
          searchAreaCollection: null,
          locationHistory: const [],
        );

  HomeState copyWith({
    HomeStatus status,
    AppConnection appConnection,
    AuthenticationData authenticationData,
    AppConfiguration appConfiguration,
    QuickActionCollection quickActions,
    MissionState missionState,
    MissionDetailCollection missionDetailCollection,
    SearchAreaCollection searchAreaCollection,
    List<LocationData> locationHistory,
    bool renewStatus,
    bool tokenExpired,
    DateTime lastupdate,
    FailureMessageKey messageKey,
  }) {
    return HomeState(
      status: status ?? this.status,
      appConnection: appConnection ?? this.appConnection,
      authenticationData: authenticationData ?? this.authenticationData,
      appConfiguration: appConfiguration ?? this.appConfiguration,
      quickActions: quickActions ?? this.quickActions,
      missionState: missionState ?? this.missionState,
      locationHistory: locationHistory ?? this.locationHistory,
      missionDetailCollection:
          missionDetailCollection ?? this.missionDetailCollection,
      searchAreaCollection: searchAreaCollection ?? this.searchAreaCollection,
      tokenExpired: tokenExpired ?? false,
      renewStatus: renewStatus ?? false,
      lastupdate: lastupdate ?? this.lastupdate,
      messageKey: messageKey,
    );
  }

  @override
  List<Object> get props => [
        status,
        appConnection,
        authenticationData,
        appConfiguration,
        quickActions,
        locationHistory,
        missionState,
        missionDetailCollection,
        searchAreaCollection,
        renewStatus,
        lastupdate,
        messageKey,
      ];
}
