import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/fetch_initialization_data.dart';

import '../../reference_types.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  FetchInitializationData usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = FetchInitializationData(mockInitializationRepository);
  });

  final tFetchInitializationDataParams = FetchInitializationDataParams(
    appConnection: tAppConnection,
    authenticationData: tAuthenticationData,
  );

  test(
    'should return InitializationData when fetching data succeeds',
    () async {
      // arrange
      when(mockInitializationRepository.fetchInitializationData(any, any))
          .thenAnswer((_) async => Right(tInitializationData));
      // act
      final result = await usecase(tFetchInitializationDataParams);
      // assert
      expect(result, Right(tInitializationData));
      verify(mockInitializationRepository.fetchInitializationData(
          tAppConnection, tAuthenticationData));
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
