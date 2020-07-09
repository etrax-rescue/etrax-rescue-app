import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';

abstract class LocalAuthenticationDataSource {
  Future<bool> cacheCredentials(String username, String token);

  Future<AuthenticationDataModel> loadCredentials();
}
