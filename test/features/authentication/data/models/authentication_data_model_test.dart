import 'package:etrax_rescue_app/features/authentication/data/models/authentication_data_model.dart';
import 'package:etrax_rescue_app/features/authentication/domain/entities/authentication_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final String tUsername = 'JohnDoe';
  final String tToken = '0123456789ABCDEF';
  final AuthenticationDataModel tAuthenticationDataModel =
      AuthenticationDataModel(username: tUsername, token: tToken);
  test(
    'should be a subclass of LoginData entity',
    () async {
      // assert
      expect(tAuthenticationDataModel, isA<AuthenticationData>());
    },
  );
}
