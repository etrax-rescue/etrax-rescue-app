part of 'base_uri_bloc.dart';

abstract class BaseUriEvent extends Equatable {
  const BaseUriEvent();
}

class StoreBaseUri extends BaseUriEvent {
  final String uriString;
  StoreBaseUri(this.uriString);

  @override
  List<Object> get props => [uriString];
}
