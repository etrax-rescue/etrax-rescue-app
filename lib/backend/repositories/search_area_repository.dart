import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../datasources/database/daos/labeled_coordinate_dao.dart';
import '../datasources/remote/remote_search_areas_data_source.dart';
import '../types/app_connection.dart';
import '../types/authentication_data.dart';
import '../types/search_area.dart';

abstract class SearchAreaRepository {
  Future<Either<Failure, SearchAreaCollection>> getSearchAreas(
      AppConnection appConnection, AuthenticationData authenticationData);

  Future<Either<Failure, None>> clearSearchAreas();
}

class SearchAreaRepositoryImpl implements SearchAreaRepository {
  SearchAreaRepositoryImpl({
    required this.networkInfo,
    required this.remoteSearchAreaDataSource,
    required this.labeledCoordinateDao,
  });

  final NetworkInfo networkInfo;
  final RemoteSearchAreaDataSource remoteSearchAreaDataSource;
  final LabeledCoordinateDao labeledCoordinateDao;

  @override
  Future<Either<Failure, SearchAreaCollection>> getSearchAreas(
      AppConnection appConnection,
      AuthenticationData authenticationData) async {
    SearchAreaCollection collection = SearchAreaCollection(areas: []);
    if (await networkInfo.isConnected) {
      bool failed = false;
      try {
        collection = await remoteSearchAreaDataSource.fetchSearchAreas(
            appConnection, authenticationData);
      } on ServerException {
        failed = true;
      } on TimeoutException {
        failed = true;
      } on SocketException {
        failed = true;
      } on AuthenticationException {
        return Left(AuthenticationFailure());
      }

      if (failed == true) {
        try {
          final ids = await labeledCoordinateDao.getDistinctIDs();
          final searchAreas = List<SearchArea>.from(
            ids.map(
              (id) async {
                final coordinates =
                    await labeledCoordinateDao.getCoordinates(id);
                final label = await labeledCoordinateDao.getLabel(id);
                final description =
                    await labeledCoordinateDao.getDescription(id);
                final color = await labeledCoordinateDao.getColorCode(id);
                return SearchArea(
                  id: id,
                  label: label,
                  description: description,
                  coordinates: coordinates,
                  color: Color(color),
                );
              },
            ),
          ).toList();
          collection = SearchAreaCollection(areas: searchAreas);
        } on InvalidDataException {
          return Left(CacheFailure());
        } on MoorWrappedException {
          return Left(PlatformFailure());
        }
        return Right(collection);
      } else {
        try {
          await labeledCoordinateDao.deleteAll();
          for (var area in collection.areas) {
            await labeledCoordinateDao.insertCoordinates(area.coordinates,
                area.id, area.label, area.description, area.color.value);
          }
        } on InvalidDataException {
          return Left(CacheFailure());
        } on MoorWrappedException {
          return Left(PlatformFailure());
        }
        return Right(collection);
      }
    } else {
      try {
        final ids = await labeledCoordinateDao.getDistinctIDs();
        List<SearchArea> searchAreas = [];
        for (var id in ids) {
          final coordinates = await labeledCoordinateDao.getCoordinates(id);
          final label = await labeledCoordinateDao.getLabel(id);
          final description = await labeledCoordinateDao.getDescription(id);
          searchAreas.add(SearchArea(
            id: id,
            label: label,
            description: description,
            coordinates: coordinates,
          ));
        }

        collection = SearchAreaCollection(areas: searchAreas);
      } on InvalidDataException {
        return Left(CacheFailure());
      } on MoorWrappedException {
        return Left(PlatformFailure());
      }
      return Right(collection);
    }
  }

  @override
  Future<Either<Failure, None>> clearSearchAreas() async {
    try {
      await labeledCoordinateDao.deleteAll();
      return Right(None());
    } on InvalidDataException {
      return Left(CacheFailure());
    } on MoorWrappedException {
      return Left(PlatformFailure());
    }
  }
}
