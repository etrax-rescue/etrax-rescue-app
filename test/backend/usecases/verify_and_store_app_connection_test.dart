import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/data/repositories/app_connection_repository_impl.dart';
import '../../../../lib/backend/domain/usecases/verify_and_store_app_connection.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepositoryImpl {}

void main() {
  VerifyAndStoreAppConnection usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = VerifyAndStoreAppConnection(mockAppConnectionRepository);
  });

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';

  test(
    'should return None when a valid uri is given',
    () async {
      // arrange
      when(mockAppConnectionRepository.verifyAndStoreAppConnection(any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(
          AppConnectionParams(authority: tAuthority, basePath: tBasePath));
      // assert
      expect(result, Right(None()));
      verify(mockAppConnectionRepository.verifyAndStoreAppConnection(
          tAuthority, tBasePath));
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
