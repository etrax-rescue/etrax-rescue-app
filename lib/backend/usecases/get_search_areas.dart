import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/search_area_repository.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/search_area.dart';
import '../types/usecase.dart';

class GetSearchAreas
    extends UseCase<SearchAreaCollection, GetSearchAreaParams> {
  GetSearchAreas(this.repository);

  final SearchAreaRepository repository;

  @override
  Future<Either<Failure, SearchAreaCollection>> call(
      GetSearchAreaParams params) async {
    return await repository.getSearchAreas(
        params.appConnection, params.authenticationData);
  }
}

class GetSearchAreaParams extends Equatable {
  GetSearchAreaParams(
      {required this.appConnection, required this.authenticationData});

  final AppConnection appConnection;
  final AuthenticationData authenticationData;

  @override
  List<Object> get props => [appConnection, authenticationData];
}
