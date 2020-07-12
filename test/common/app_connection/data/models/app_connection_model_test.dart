import 'package:etrax_rescue_app/common/app_connection/data/models/app_connection_model.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/entities/app_connection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tAppConnectionModel =
      AppConnectionModel(baseUri: 'https://www.etrax.at');
  test(
    'should be a subclass of AppConnection entity',
    () async {
      // assert
      expect(tAppConnectionModel, isA<AppConnection>());
    },
  );
}
