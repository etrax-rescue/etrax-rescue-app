import 'package:moor/moor.dart';

import '../database.dart';
import '../models/labeled_coordinate_model.dart';
import 'package:latlong2/latlong.dart';

part 'labeled_coordinate_dao.g.dart';

abstract class LabeledCoordinateDao {
  Future<List<String>> getDistinctIDs();
  Future<void> insertCoordinates(List<LatLng> coordinates, String id,
      String label, String description, int colorCode);
  Future<List<LatLng>> getCoordinates(String id);
  Future<String> getLabel(String id);
  Future<String> getDescription(String id);
  Future<int> getColorCode(String id);
  Future<void> deleteAll();
}

@UseDao(tables: [LabeledCoordinateModels])
class LabeledCoordinateDaoImpl extends DatabaseAccessor<AppDatabase>
    with _$LabeledCoordinateDaoImplMixin
    implements LabeledCoordinateDao {
  LabeledCoordinateDaoImpl(AppDatabase db) : super(db);

  @override
  Future<List<String>> getDistinctIDs() async {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.id]);

    final result =
        await query.map((row) => row.read(db.labeledCoordinateModels.id)).get();
    return result.whereType<String>().toList();
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
      String label, String description, int colorCode) async {
    await batch((batch) {
      batch.insertAll(db.labeledCoordinateModels, [
        for (var coordinate in coordinates)
          LabeledCoordinateModelsCompanion.insert(
              id: id,
              label: label,
              color: Value(colorCode),
              description: description,
              latitude: coordinate.latitude,
              longitude: coordinate.longitude)
      ]);
    });
  }

  @override
  Future<String> getLabel(String id) async {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.label])
      ..where(db.labeledCoordinateModels.id.equals(id))
      ..limit(1);
    ;
    final result = await query
        .map((row) => row.read(db.labeledCoordinateModels.label))
        .getSingle();
    return result ?? "";
  }

  @override
  Future<String> getDescription(String id) async {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.description])
      ..where(db.labeledCoordinateModels.id.equals(id))
      ..limit(1);
    ;
    ;
    final result = await query
        .map((row) => row.read(db.labeledCoordinateModels.description))
        .getSingle();
    return result ?? "";
  }

  @override
  Future<int> getColorCode(String id) async {
    final query = selectOnly(db.labeledCoordinateModels, distinct: true)
      ..addColumns([db.labeledCoordinateModels.color])
      ..where(db.labeledCoordinateModels.id.equals(id))
      ..limit(1);
    ;
    final result = await query
        .map((row) => row.read(db.labeledCoordinateModels.color))
        .getSingle();

    return result ?? 0;
  }
}
