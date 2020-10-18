import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/app_connection_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/delete_app_connection.dart';
import 'package:etrax_rescue_app/backend/types/usecase.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepository {}

void main() {
  DeleteAppConnection usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = DeleteAppConnection(mockAppConnectionRepository);
  });

  test(
    'should call the delete method of the AppConnectionRepository',
    () async {
      // arrange
      when(mockAppConnectionRepository.deleteAppConnection())
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(None()));
      verify(mockAppConnectionRepository.deleteAppConnection());
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
