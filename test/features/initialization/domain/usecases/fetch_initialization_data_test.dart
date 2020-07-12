import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/features/initialization/domain/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/features/initialization/domain/usecases/fetch_initialization_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  FetchInitializationData usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = FetchInitializationData(mockInitializationRepository);
  });

  final tBaseUri = 'https://etrax.at/appdata';
  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';
  final tFetchInitializationDataParams = FetchInitializationDataParams(
    baseUri: tBaseUri,
    username: tUsername,
    token: tToken,
  );

  test(
    'should return None when fetching data succeeds',
    () async {
      // arrange
      when(mockInitializationRepository.fetchInitializationData(any, any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(tFetchInitializationDataParams);
      // assert
      expect(result, Right(None()));
      verify(mockInitializationRepository.fetchInitializationData(
          tBaseUri, tUsername, tToken));
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
