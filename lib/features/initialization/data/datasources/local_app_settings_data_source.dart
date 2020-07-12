import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';

abstract class LocalAppSettingsDataSource {
  Future<void> storeAppSettings(AppSettingsModel settings);

  Future<AppSettingsModel> getAppSettings();

  Future<void> clearAppSettings();
}
