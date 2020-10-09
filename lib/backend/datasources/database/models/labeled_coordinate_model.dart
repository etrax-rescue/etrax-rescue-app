import 'package:moor/moor.dart';

class LabeledCoordinateModels extends Table {
  IntColumn get index => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get description => text()();
  IntColumn get color => integer().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}
