import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'launch_event.dart';
part 'launch_state.dart';

class LaunchBloc extends Bloc<LaunchEvent, LaunchState> {
  LaunchBloc() : super(LaunchInitial());

  @override
  Stream<LaunchState> mapEventToState(
    LaunchEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
