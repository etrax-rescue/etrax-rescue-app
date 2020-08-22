part of 'initialization_bloc.dart';

abstract class InitializationEvent extends Equatable {
  const InitializationEvent();
  @override
  List<Object> get props => [];
}

class StartFetchingInitializationData extends InitializationEvent {}

class GetAllMissions extends InitializationEvent {}
