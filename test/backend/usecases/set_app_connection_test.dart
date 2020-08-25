import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/backend/repositories/app_state_repository.dart';
import '../../../lib/backend/usecases/set_app_connection.dart';

class MockAppStateRepository extends Mock implements AppStateRepository {}

void main() {
  SetAppConnection usecase;
  MockAppStateRepository mockAppStateRepository;

  setUp(() {
    mockAppStateRepository = MockAppStateRepository();
    usecase = SetAppConnection(mockAppStateRepository);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';

  test(
    'should return None when a valid uri is given',
    () async {
      // arrange
      when(mockAppStateRepository.setAppConnection(any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(
          AppConnectionParams(authority: tAuthority, basePath: tBasePath));
      // assert
      expect(result, Right(None()));
      verify(mockAppStateRepository.setAppConnection(tAuthority, tBasePath));
      verifyNoMoreInteractions(mockAppStateRepository);
    },
  );
}
