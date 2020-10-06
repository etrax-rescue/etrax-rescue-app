import 'package:moor/moor.dart';

import '../database.dart';
import '../models/geo_vertex_model.dart';

part 'geo_vertex_dao.g.dart';

abstract class GeoVertexDao {
  Future<void> insertVertices(List<Insertable<GeoVertexModel>> models);
  Future<List<GeoVertexModel>> getVertices(int area_id);
  Future<void> deleteAllVertices();
}

@UseDao(tables: [GeoVertexModels])
class GeoVertexDaoImpl extends DatabaseAccessor<AppDatabase>
    with _$GeoVertexDaoImplMixin
    implements GeoVertexDao {
  GeoVertexDaoImpl(AppDatabase db) : super(db);

  @override
  Future<List<GeoVertexModel>> getVertices(int area_id) async {
    return await select(db.geoVertexModels).get();
  }

  @override
  Future<void> deleteAllVertices() async {
    await delete(db.geoVertexModels).go();
  }

  @override
  Future<void> insertVertices(List<Insertable<GeoVertexModel>> models) async {
    await batch((batch) {
      batch.insertAll(db.geoVertexModels, models);
    });
  }
}
