import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../types/app_connection.dart';
import '../../types/authentication_data.dart';
import '../../types/etrax_server_endpoints.dart';
import '../../types/poi.dart';

abstract class RemotePoiDataSource {
  Future<Stream<double>> sendPoi(AppConnection appConnection,
      AuthenticationData authenticationData, Poi poi);
}

class RemotePoiDataSourceImpl implements RemotePoiDataSource {
  RemotePoiDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<Stream<double>> sendPoi(AppConnection appConnection,
      AuthenticationData authenticationData, Poi poi) async {
    final controller = StreamController<double>();

    FormData formData = FormData.fromMap({
      'location_data': json.encode(poi.locationData.toMap()),
      'description': poi.description,
      'image': MultipartFile.fromFileSync(poi.imagePath, filename: 'image')
    });

    final response = dio.post(
      appConnection
          .generateUri(subPath: EtraxServerEndpoints.uploadPoi)
          .toString(),
      data: formData,
      options: Options(
        headers: authenticationData.generateAuthHeader(),
      ),
      onSendProgress: (int sent, int total) {
        double progress = sent.toDouble() / total;
        if (progress < 1.0) {
          controller.add(progress);
        }
      },
    );

    response.then((response) {
      if (response.statusCode == 201) {
        controller.add(1.0);
        controller.close();
      } else if (response.statusCode == 401) {
        controller.addError(AuthenticationFailure());
        controller.close();
      } else {
        controller.addError(ServerFailure());
        controller.close();
      }
    }, onError: (error) {
      controller.addError(ServerFailure());
      controller.close();
    });

    return controller.stream;
  }
}
