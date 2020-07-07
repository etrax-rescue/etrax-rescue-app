import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestInitial());

  @override
  Stream<TestState> mapEventToState(
    TestEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
