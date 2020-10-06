import 'package:moor/moor.dart';

class GeoPolygonModels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
