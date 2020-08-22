part of 'app_connection_bloc.dart';

abstract class AppConnectionEvent extends Equatable {
  const AppConnectionEvent();
  @override
  List<Object> get props => [];
}

class AppConnectionEventCheck extends AppConnectionEvent {}

class AppConnectionEventConnect extends AppConnectionEvent {
  final String authority;
  AppConnectionEventConnect({@required this.authority});

  @override
  List<Object> get props => [authority];
}
