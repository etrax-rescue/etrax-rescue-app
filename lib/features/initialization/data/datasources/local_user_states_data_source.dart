import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';

abstract class LocalUserStatesDataSource {
  Future<void> storeUserStates(UserStateCollectionModel states);

  Future<UserStateCollectionModel> getUserStates();

  Future<void> clearUserStates();
}
