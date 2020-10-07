import 'package:moor/moor.dart';

import '../database.dart';
import '../models/labeled_coordinate_model.dart';
import 'package:latlong/latlong.dart';

part 'labeled_coordinate_dao.g.dart';

abstract class LabeledCoordinateDao {
  Future<List<String>> getDistinctIDs();
  Future<void> insertCoordinates(
      List<LatLng> coordinates, String id, String label, String description);
  Future<List<LatLng>> getCoordinates(String id);
  Future<String> getLabel(String id);
  Future<String> getDescription(String id);
  Future<void> deleteAll();
}

@UseDao(tables: [LabeledCoordinateModels])
class LabeledCoordinateDaoImpl extends DatabaseAccessor<AppDatabase>
    with _$LabeledCoordinateDaoImplMixin
    implements LabeledCoordinateDao {
  LabeledCoordinateDaoImpl(AppDatabase db) : super(db);

  @override
  Future<List<String>> getDistinctIDs() {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.id]);
    return query.map((row) => row.read(db.labeledCoordinateModels.id)).get();
  }

  @override
  Future<List<LatLng>> getCoordinates(String id) {
    final query = select(db.labeledCoordinateModels)
      ..where((t) => t.id.equals(id));
    return query.map((row) => LatLng(row.latitude, row.longitude)).get();
  }

  @override
  Future<void> deleteAll() async {
    await delete(db.labeledCoordinateModels).go();
  }

  @override
  Future<void> insertCoordinates(List<LatLng> coordinates, String id,
      String label, String description) async {
    final models = coordinates
        .map((coordinate) => LabeledCoordinateModelsCompanion.insert(
            id: id,
            label: label,
            description: description,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude))
        .toList();
    await batch((batch) {
      batch.insertAll(db.labeledCoordinateModels, models);
    });
  }

  @override
  Future<String> getLabel(String id) {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.label]);
    ;
    return query
        .map((row) => row.read(db.labeledCoordinateModels.label))
        .getSingle();
  }

  @override
  Future<String> getDescription(String id) {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.description]);
    ;
    return query
        .map((row) => row.read(db.labeledCoordinateModels.description))
        .getSingle();
  }
}
