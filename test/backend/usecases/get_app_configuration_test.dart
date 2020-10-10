import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_app_configuration.dart';

import '../../reference_types.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetAppConfiguration usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetAppConfiguration(mockInitializationRepository);
  });

  test(
    'should return AppConfiguration when they are available',
    () async {
      // arrange
      when(mockInitializationRepository.getAppConfiguration())
          .thenAnswer((_) async => Right(tAppConfiguration));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tAppConfiguration));
      verify(mockInitializationRepository.getAppConfiguration());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
