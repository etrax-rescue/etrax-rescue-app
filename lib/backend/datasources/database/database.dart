import 'package:moor/moor.dart';

import 'daos/labeled_coordinate_dao.dart';
import 'models/labeled_coordinate_model.dart';

part 'database.g.dart';

@UseMoor(tables: [LabeledCoordinateModels], daos: [LabeledCoordinateDaoImpl])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // we added the color property in the change from version 1
          await m.addColumn(
              labeledCoordinateModels, labeledCoordinateModels.color);
        }
      });
}
