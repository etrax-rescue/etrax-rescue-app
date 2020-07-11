import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/common/app_connect/domain/repositories/base_uri_repository.dart';
import 'package:etrax_rescue_app/common/app_connect/domain/usecases/get_base_uri.dart';
import 'package:etrax_rescue_app/common/app_connect/domain/entities/base_uri.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBaseUriRepository extends Mock implements BaseUriRepository {}

void main() {
  GetBaseUri usecase;
  MockBaseUriRepository mockServerLinkRepository;

  setUp(() {
    mockServerLinkRepository = MockBaseUriRepository();
    usecase = GetBaseUri(mockServerLinkRepository);
  });

  final tBaseUri = BaseUri(baseUri: 'https://etrax.at/appdata/');

  test(
    'should return a valid base uri',
    () async {
      // arrange
      when(mockServerLinkRepository.getBaseUri())
          .thenAnswer((_) async => Right(tBaseUri));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tBaseUri));
      verify(mockServerLinkRepository.getBaseUri());
      verifyNoMoreInteractions(mockServerLinkRepository);
    },
  );
}
