import 'package:http/http.dart' as http;

import '../models/initialization_data_model.dart';

abstract class RemoteInitializationDataSource {
  Future<InitializationDataModel> fetchInitialization(
      String baseUri, String username, String token);
}

class RemoteInitializationDataSourceImpl
    implements RemoteInitializationDataSource {
  final http.Client client;
  RemoteInitializationDataSourceImpl(this.client);

  @override
  Future<InitializationDataModel> fetchInitialization(
      String baseUri, String username, String token) {
    // TODO: implement fetchInitialization
    throw UnimplementedError();
  }
}
