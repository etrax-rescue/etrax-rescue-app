part of 'initialization_bloc.dart';

abstract class InitializationEvent extends Equatable {
  const InitializationEvent();
}

class StartFetchingInitializationData extends InitializationEvent {
  @override
  List<Object> get props => [];
}

class GetAllMissions extends InitializationEvent {
  @override
  List<Object> get props => [];
}
