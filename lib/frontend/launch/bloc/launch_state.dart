part of 'launch_bloc.dart';

abstract class LaunchState extends Equatable {
  const LaunchState();
  
  @override
  List<Object> get props => [];
}

class LaunchInitial extends LaunchState {}
