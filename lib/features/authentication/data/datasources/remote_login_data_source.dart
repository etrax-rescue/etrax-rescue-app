import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';

abstract class RemoteLoginDataSource {
  Future<AuthenticationDataModel> login(
      String baseUri, String username, String password);
}
