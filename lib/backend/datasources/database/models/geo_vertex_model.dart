import 'package:moor/moor.dart';

class GeoVertexModels extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get polygon_id =>
      integer().customConstraint('REFERENCES geo_polygon_models(id)')();
}
