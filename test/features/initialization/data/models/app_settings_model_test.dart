import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tLocationUpdateInterval = 0;
  final tAppSettingsModel =
      AppSettingsModel(locationUpdateInterval: tLocationUpdateInterval);
  test(
    'should be a subclass of Missions entity',
    () async {
      // assert
      expect(tAppSettingsModel, isA<AppSettings>());
    },
  );
}
