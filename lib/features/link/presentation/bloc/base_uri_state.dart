part of 'base_uri_bloc.dart';

abstract class BaseUriState extends Equatable {
  const BaseUriState();
}

class BaseUriInitial extends BaseUriState {
  @override
  List<Object> get props => [];
}

class BaseUriVerifying extends BaseUriState {
  @override
  List<Object> get props => [];
}

class BaseUriStored extends BaseUriState {
  @override
  List<Object> get props => [];
}

class BaseUriError extends BaseUriState {
  final String message;

  BaseUriError({@required this.message});

  @override
  List<Object> get props => [message];
}
