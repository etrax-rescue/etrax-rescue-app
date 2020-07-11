part of 'app_connect_bloc.dart';

abstract class AppConnectEvent extends Equatable {
  const AppConnectEvent();
}

class ConnectApp extends AppConnectEvent {
  final String uriString;
  ConnectApp({@required this.uriString});

  @override
  List<Object> get props => [uriString];
}
