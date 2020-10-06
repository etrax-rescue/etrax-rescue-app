import 'package:moor/moor.dart';

class SearchAreaModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get area_id => integer()();
}
