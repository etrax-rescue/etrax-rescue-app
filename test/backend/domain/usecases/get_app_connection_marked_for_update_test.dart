import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/backend/domain/repositories/app_connection_repository.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/backend/domain/usecases/get_app_connection_marked_for_update.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
