import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/usecase.dart';
import '../../../../lib/backend/types/app_configuration.dart';
import '../../../../lib/backend/domain/repositories/initialization_repository.dart';
import '../../../../lib/backend/domain/usecases/get_app_configuration.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetAppConfiguration usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetAppConfiguration(mockInitializationRepository);
  });

  final tLocationUpdateInterval = 0;
  final tLocationUpdateMinDistance = 50;
  final tInfoUpdateInterval = 300;
  final tAppConfiguration = AppConfiguration(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);

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
