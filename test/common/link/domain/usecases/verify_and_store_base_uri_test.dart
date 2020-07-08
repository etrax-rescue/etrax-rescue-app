import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/link/data/repositories/base_uri_repository_impl.dart';
import 'package:etrax_rescue_app/common/link/domain/usecases/verify_and_store_base_uri.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBaseUriRepository extends Mock implements BaseUriRepositoryImpl {}

void main() {
  VerifyAndStoreBaseUri usecase;
  MockBaseUriRepository mockServerLinkRepository;

  setUp(() {
    mockServerLinkRepository = MockBaseUriRepository();
    usecase = VerifyAndStoreBaseUri(mockServerLinkRepository);
  });

  final tUriString = 'https://etrax.at/appdata/';

  test(
    'should return None when a valid uri is given',
    () async {
      // arrange
      when(mockServerLinkRepository.verifyAndStoreBaseUri(any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(BaseUriParams(baseUri: tUriString));
      // assert
      expect(result, Right(None()));
      verify(mockServerLinkRepository.verifyAndStoreBaseUri(tUriString));
      verifyNoMoreInteractions(mockServerLinkRepository);
    },
  );
}
