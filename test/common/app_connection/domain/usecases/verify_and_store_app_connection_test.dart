import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/app_connection/data/repositories/app_connection_repository_impl.dart';
import 'package:etrax_rescue_app/common/app_connection/domain/usecases/verify_and_store_app_connection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepositoryImpl {}

void main() {
  VerifyAndStoreAppConnection usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = VerifyAndStoreAppConnection(mockAppConnectionRepository);
  });

  final tUriString = 'https://etrax.at/appdata/';

  test(
    'should return None when a valid uri is given',
    () async {
      // arrange
      when(mockAppConnectionRepository.verifyAndStoreAppConnection(any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(AppConnectionParams(baseUri: tUriString));
      // assert
      expect(result, Right(None()));
      verify(
          mockAppConnectionRepository.verifyAndStoreAppConnection(tUriString));
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
