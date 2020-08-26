import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_state_event.dart';
part 'update_state_state.dart';

class UpdateStateBloc extends Bloc<UpdateStateEvent, UpdateStateState> {
  UpdateStateBloc() : super(UpdateStateInitial());

  @override
  Stream<UpdateStateState> mapEventToState(
    UpdateStateEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
