import 'package:latlong/latlong.dart';
import 'package:moor/moor.dart';

import '../../../types/search_area.dart';
import '../database.dart';
import '../models/search_area_model.dart';

part 'search_area_dao.g.dart';

abstract class SearchAreaDao {
  Future<SearchArea> getSearchArea();
}

@UseDao(tables: [SearchAreaModel])
class SearchAreaDaoImpl extends DatabaseAccessor<AppDatabase>
    with _$SearchAreaDaoImplMixin
    implements SearchAreaDao {
  SearchAreaDaoImpl(AppDatabase db) : super(db);

  @override
  Future<SearchArea> getSearchArea() async {
    final result = await select(searchAreaModel).get();
    final coordinates =
        List<LatLng>.from(result.map((e) => LatLng(e.latitude, e.longitude)))
            .toList();
    return SearchArea(coordinates: coordinates);
  }
}
