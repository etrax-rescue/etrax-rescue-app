import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:etrax_rescue_app/backend/datasources/database/database.dart';
import 'package:etrax_rescue_app/backend/datasources/database/daos/geo_vertex_dao.dart';
import 'package:etrax_rescue_app/backend/datasources/database/daos/geo_polygon_dao.dart';

import '../../../../reference_types.dart';

void main() {
  AppDatabase database;
  GeoVertexDao vertexDao;
  GeoPolygonDao polygonDao;

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    vertexDao = database.geoVertexDaoImpl;
    polygonDao = database.geoPolygonDaoImpl;
  });

  tearDown(() async {
    await database.close();
  });

  final tGeoPolygonID = 1;
  final tGeoPolygonName = 'test';
  final tGeoPolygonModel =
      GeoPolygonModel(id: tGeoPolygonID, name: tGeoPolygonName);
  final tGeoPolygonModelList = [tGeoPolygonModel];

  final tGeoVertexModel = GeoVertexModelsCompanion(
    latitude: Value(tLatitude),
    longitude: Value(tLongitude),
    polygon_id: Value(tGeoPolygonID),
  );

  final tGeoVertexModelModelList = [tGeoVertexModel, tGeoVertexModel];

  group('DAO tests', () {
    setUp(() {
      polygonDao.insertPolygons(tGeoPolygonModelList);
      vertexDao.insertVertices(tGeoVertexModelModelList);
    });

    test(
      'should return a valid search area',
      () async {
        // arrange
        final expected = [
          GeoVertexModel(
            id: 1,
            latitude: tLatitude,
            longitude: tLongitude,
            polygon_id: tGeoPolygonID,
          ),
          GeoVertexModel(
            id: 2,
            latitude: tLatitude,
            longitude: tLongitude,
            polygon_id: tGeoPolygonID,
          )
        ];
        // act
        final result = await vertexDao.getVertices(tGeoPolygonID);
        // assert
        expect(result, expected);
      },
    );

    tearDown(() {
      vertexDao.deleteAllVertices();
      polygonDao.deleteAllPolygons();
    });
  });
}
