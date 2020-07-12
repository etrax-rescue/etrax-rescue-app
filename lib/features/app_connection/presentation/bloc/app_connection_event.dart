part of 'app_connection_bloc.dart';

abstract class AppConnectionEvent extends Equatable {
  const AppConnectionEvent();
}

class ConnectApp extends AppConnectionEvent {
  final String uriString;
  ConnectApp({@required this.uriString});

  @override
  List<Object> get props => [uriString];
}
