import 'package:moor/moor.dart';

import 'daos/labeled_coordinate_dao.dart';
import 'models/labeled_coordinate_model.dart';

part 'database.g.dart';

@UseMoor(tables: [LabeledCoordinateModels], daos: [LabeledCoordinateDaoImpl])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}
