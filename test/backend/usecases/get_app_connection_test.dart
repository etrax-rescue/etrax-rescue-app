import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/app_connection_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_app_connection.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';

import '../../reference_types.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepository {}

void main() {
  GetAppConnection usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = GetAppConnection(mockAppConnectionRepository);
  });

  test(
    'should return a valid base uri',
    () async {
      // arrange
      when(mockAppConnectionRepository.getAppConnection())
          .thenAnswer((_) async => Right(tAppConnection));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tAppConnection));
      verify(mockAppConnectionRepository.getAppConnection());
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
