import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/usecase.dart';
import '../../../../lib/backend/domain/repositories/authentication_repository.dart';
import '../../../../lib/backend/domain/usecases/delete_authentication_data.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  DeleteAuthenticationData usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = DeleteAuthenticationData(mockAuthenticationRepository);
  });

  test(
    'should return None when the data was successfully deleted',
    () async {
      // arrange
      when(mockAuthenticationRepository.deleteAuthenticationData())
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(None()));
      verify(mockAuthenticationRepository.deleteAuthenticationData());
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
