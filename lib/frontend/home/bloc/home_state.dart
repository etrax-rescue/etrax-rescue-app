part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  ready,
  closed,
}

class HomeState extends Equatable {
  const HomeState({
    @required this.status,
    @required this.missionState,
    @required this.locationHistory,
  });

  final HomeStatus status;
  final List<LocationData> locationHistory;
  final MissionState missionState;

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
          missionState: null,
          locationHistory: const [],
        );

  const HomeState.closed()
      : this(
          status: HomeStatus.closed,
          missionState: null,
          locationHistory: const [],
        );

  HomeState copyWith(
      {HomeStatus status,
      MissionState missionState,
      List<LocationData> locationHistory}) {
    return HomeState(
      status: status ?? this.status,
      missionState: missionState ?? this.missionState,
      locationHistory: locationHistory ?? this.locationHistory,
    );
  }

  @override
  List<Object> get props => [status, locationHistory, missionState];
}
