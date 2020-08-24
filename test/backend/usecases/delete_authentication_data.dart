import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/usecase.dart';
import '../../../../lib/backend/domain/repositories/login_repository.dart';
import '../../../../lib/backend/domain/usecases/delete_authentication_data.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  DeleteAuthenticationData usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = DeleteAuthenticationData(mockLoginRepository);
  });

  test(
    'should return None when the data was successfully deleted',
    () async {
      // arrange
      when(mockLoginRepository.deleteAuthenticationData())
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(None()));
      verify(mockLoginRepository.deleteAuthenticationData());
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
