import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tID = 42;
  final tName = 'approaching';
  final tDescription = 'is on its way';
  final tUserStateModel =
      UserStateModel(id: tID, name: tName, description: tDescription);
  final tUserStatesModel =
      UserStatesModel(states: <UserStateModel>[tUserStateModel]);

  test(
    'should be a subclass of Missions entity',
    () async {
      // assert
      expect(tUserStatesModel, isA<UserStates>());
    },
  );
}
