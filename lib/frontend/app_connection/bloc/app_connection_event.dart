part of 'app_connection_bloc.dart';

abstract class AppConnectionEvent extends Equatable {
  const AppConnectionEvent();
  @override
  List<Object> get props => [];
}

class SubmitAppConnection extends AppConnectionEvent {
  final String authority;
  SubmitAppConnection({@required this.authority});

  @override
  List<Object> get props => [authority];
}
