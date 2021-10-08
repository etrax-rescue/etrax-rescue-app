// @dart=2.9
part of 'launch_bloc.dart';

abstract class LaunchEvent extends Equatable {
  const LaunchEvent();

  @override
  List<Object> get props => [];
}

class Launch extends LaunchEvent {}
