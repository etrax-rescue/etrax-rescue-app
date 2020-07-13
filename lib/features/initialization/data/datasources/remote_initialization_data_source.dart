import 'package:etrax_rescue_app/features/initialization/data/models/initialization_data_model.dart';

abstract class RemoteInitializationDataSource {
  Future<InitializationDataModel> fetchInitialization(
      String baseUri, String username, String token);
}

class RemoteInitializationDataSourceImpl
    implements RemoteInitializationDataSource {
  @override
  Future<InitializationDataModel> fetchInitialization(
      String baseUri, String username, String token) {
    // TODO: implement fetchInitialization
    throw UnimplementedError();
  }
}
