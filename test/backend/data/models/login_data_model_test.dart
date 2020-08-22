import 'package:etrax_rescue_app/backend/data/models/login_data_model.dart';
import 'package:etrax_rescue_app/backend/domain/entities/login_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final String tUsername = 'JohnDoe';
  final String tPassword = '0123456789ABCDEF';
  final LoginDataModel tLoginDataModel =
      LoginDataModel(username: tUsername, password: tPassword);
  test(
    'should be a subclass of LoginData entity',
    () async {
      // assert
      expect(tLoginDataModel, isA<LoginData>());
    },
  );
}
