import 'package:moor/moor.dart';

import '../database.dart';
import '../models/geo_polygon_model.dart';

part 'geo_polygon_dao.g.dart';

abstract class GeoPolygonDao {
  Future<void> insertPolygons(List<Insertable<GeoPolygonModel>> models);
  Future<List<GeoPolygonModel>> getPolygons();
  Future<void> deleteAllPolygons();
}

@UseDao(tables: [GeoPolygonModels])
class GeoPolygonDaoImpl extends DatabaseAccessor<AppDatabase>
    with _$GeoPolygonDaoImplMixin
    implements GeoPolygonDao {
  GeoPolygonDaoImpl(AppDatabase db) : super(db);

  @override
  Future<List<GeoPolygonModel>> getPolygons() async {
    return await select(db.geoPolygonModels).get();
  }

  @override
  Future<void> deleteAllPolygons() async {
    await delete(db.geoPolygonModels).go();
  }

  @override
  Future<void> insertPolygons(List<Insertable<GeoPolygonModel>> models) async {
    await batch((batch) {
      batch.insertAll(db.geoPolygonModels, models);
    });
  }
}
