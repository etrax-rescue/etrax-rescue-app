import 'package:flutter_test/flutter_test.dart';

import '../../../lib/backend/types/login_data.dart';

void main() {
  final String tUsername = 'JohnDoe';
  final String tPassword = '0123456789ABCDEF';
  final LoginData tLoginData =
      LoginData(username: tUsername, password: tPassword);
  test(
    'should be a subclass of LoginData entity',
    () async {
      // assert
      expect(tLoginData, isA<LoginData>());
    },
  );
}
