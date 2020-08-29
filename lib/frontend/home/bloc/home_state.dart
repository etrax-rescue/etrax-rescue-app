part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({@required this.currentLocation});

  final LocationData currentLocation;

  const HomeState.initial() : this(currentLocation: null);

  const HomeState.locationUpdate({@required LocationData locationData})
      : this(currentLocation: locationData);

  const HomeState.closed() : this(currentLocation: null);

  HomeState copyWith({LocationData locationData}) {
    return HomeState(currentLocation: locationData);
  }

  @override
  List<Object> get props => [currentLocation];
}
