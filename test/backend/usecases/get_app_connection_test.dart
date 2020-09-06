import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/mission_state_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';

class MockAppStateRepository extends Mock implements AppStateRepository {}

void main() {
  GetAppConnection usecase;
  MockAppStateRepository mockAppStateRepository;

  setUp(() {
    mockAppStateRepository = MockAppStateRepository();
    usecase = GetAppConnection(mockAppStateRepository);
  });

  final tBaseUri = AppConnection(authority: 'etrax.at', basePath: 'appdata');

  test(
    'should return a valid base uri',
    () async {
      // arrange
      when(mockAppStateRepository.getAppConnection())
          .thenAnswer((_) async => Right(tBaseUri));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tBaseUri));
      verify(mockAppStateRepository.getAppConnection());
      verifyNoMoreInteractions(mockAppStateRepository);
    },
  );
}
