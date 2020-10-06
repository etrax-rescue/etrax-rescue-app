import 'package:etrax_rescue_app/backend/datasources/database/daos/geo_vertex_dao.dart';
import 'package:moor/moor.dart';

import 'daos/geo_polygon_dao.dart';
import 'models/geo_polygon_model.dart';
import 'models/geo_vertex_model.dart';

part 'database.g.dart';

@UseMoor(
    tables: [GeoPolygonModels, GeoVertexModels],
    daos: [GeoPolygonDaoImpl, GeoVertexDaoImpl])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
