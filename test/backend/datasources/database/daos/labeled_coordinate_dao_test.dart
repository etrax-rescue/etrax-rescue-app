import 'package:latlong/latlong.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:etrax_rescue_app/backend/datasources/database/database.dart';
import 'package:etrax_rescue_app/backend/datasources/database/daos/labeled_coordinate_dao.dart';

import '../../../../reference_types.dart';

void main() {
  AppDatabase database;
  LabeledCoordinateDao dao;

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    dao = database.labeledCoordinateDaoImpl;
  });

  tearDown(() async {
    await database.close();
  });

  final tSID = 'SID';
  final tLabel = 'test';
  final tDescription = 'Suchgebiet';
  final tCoordinates = [LatLng(tLatitude, tLongitude)];
  final tColorCode = 0;

  group('DAO tests', () {
    setUp(() {
      dao.insertCoordinates(
          tCoordinates, tSID, tLabel, tDescription, tColorCode);
    });

    test(
      'should return a list of valid IDs',
      () async {
        // act
        final result = await dao.getDistinctIDs();
        // assert
        expect(result, [tSID]);
      },
    );

    test(
      'should return valid label',
      () async {
        // act
        final result = await dao.getLabel(tSID);
        // assert
        expect(result, tLabel);
      },
    );

    test(
      'should return valid description',
      () async {
        // act
        final result = await dao.getDescription(tSID);
        // assert
        expect(result, tDescription);
      },
    );

    test(
      'should return valid coordinates',
      () async {
        // act
        final result = await dao.getCoordinates(tSID);
        // assert
        expect(result, tCoordinates);
      },
    );

    test(
      'should return valid color code',
      () async {
        // act
        final result = await dao.getColorCode(tSID);
        // assert
        expect(result, tColorCode);
      },
    );

    tearDown(() {
      dao.deleteAll();
    });
  });
}
