part of 'app_connection_bloc.dart';

abstract class AppConnectionEvent extends Equatable {
  const AppConnectionEvent();
}

class ConnectApp extends AppConnectionEvent {
  final String authority;
  ConnectApp({@required this.authority});

  @override
  List<Object> get props => [authority];
}
