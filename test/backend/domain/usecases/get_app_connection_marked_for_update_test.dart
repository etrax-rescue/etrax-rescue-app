import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/domain/repositories/app_connection_repository.dart';
import '../../../../lib/backend/types/usecase.dart';
import '../../../../lib/backend/domain/usecases/get_app_connection_marked_for_update.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepository {}

void main() {
  GetAppConnectionMarkedForUpdate usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = GetAppConnectionMarkedForUpdate(mockAppConnectionRepository);
  });

  test(
    'should return a valid base uri',
    () async {
      // arrange
      when(mockAppConnectionRepository.getAppConnectionUpdateStatus())
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(true));
      verify(mockAppConnectionRepository.getAppConnectionUpdateStatus());
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
