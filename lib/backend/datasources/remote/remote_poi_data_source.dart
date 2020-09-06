import 'dart:async';

import 'package:dio/dio.dart';
import 'package:etrax_rescue_app/backend/types/etrax_server_endpoints.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';

import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/poi.dart';

abstract class RemotePoiDataSource {
  Future<Stream<double>> sendPoi(AppConnection appConnection,
      AuthenticationData authenticationData, Poi poi);
}

class RemotePoiDataSourceImpl implements RemotePoiDataSource {
  final Dio dio;

  RemotePoiDataSourceImpl(this.dio);

  @override
  Future<Stream<double>> sendPoi(AppConnection appConnection,
      AuthenticationData authenticationData, Poi poi) async {
    final controller = StreamController<double>();

    FormData formData = FormData.fromMap({
      "location_data": poi.locationData.toMap().toString(),
      "description": poi.description,
      "file": await MultipartFile.fromFile(poi.imagePath, filename: 'image.jpg')
    });

    try {
      dio.post(
        appConnection
            .generateUri(subPath: EtraxServerEndpoints.uploadPoi)
            .toString(),
        data: formData,
        options: Options(
          headers: authenticationData.generateAuthHeader(),
        ),
        onSendProgress: (int sent, int total) {
          controller.add(sent.toDouble() / total);
        },
      );
    } on DioError {
      controller.close();
      throw ServerException();
    }
    return controller.stream;
  }
}
