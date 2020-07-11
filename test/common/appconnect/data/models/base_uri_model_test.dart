import 'package:etrax_rescue_app/common/app_connect/data/models/base_uri_model.dart';
import 'package:etrax_rescue_app/common/app_connect/domain/entities/base_uri.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tBaseUriModel = BaseUriModel(baseUri: 'https://www.etrax.at');
  test(
    'should be a subclass of BaseUri entity',
    () async {
      // assert
      expect(tBaseUriModel, isA<BaseUri>());
    },
  );
}
