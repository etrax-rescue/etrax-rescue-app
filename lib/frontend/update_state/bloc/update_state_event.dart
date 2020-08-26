part of 'update_state_bloc.dart';

abstract class UpdateStateEvent extends Equatable {
  const UpdateStateEvent();

  @override
  List<Object> get props => [];
}

class SubmitState extends UpdateStateEvent {
  final UserState state;
  SubmitState({@required this.state});

  @override
  List<Object> get props => [state];
}
