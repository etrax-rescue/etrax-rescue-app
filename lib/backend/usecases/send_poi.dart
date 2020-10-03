import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/error/failures.dart';
import '../repositories/poi_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/poi.dart';
import '../types/usecase.dart';

class SendPoi extends UseCase<Stream<double>, SendPoiParams> {
  SendPoi(this.repository);

  final PoiRepository repository;

  @override
  Future<Either<Failure, Stream<double>>> call(SendPoiParams params) async {
    return await repository.sendPOI(
        params.appConnection, params.authenticationData, params.poi);
  }
}

class SendPoiParams extends Equatable {
  SendPoiParams(
      {@required this.appConnection,
      @required this.authenticationData,
      @required this.poi});

  final AppConnection appConnection;
  final AuthenticationData authenticationData;
  final Poi poi;

  @override
  List<Object> get props => [appConnection, authenticationData, poi];
}
