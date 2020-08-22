import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/core/types/usecase.dart';
import '../../../../lib/backend/domain/entities/app_settings.dart';
import '../../../../lib/backend/domain/repositories/initialization_repository.dart';
import '../../../../lib/backend/domain/usecases/get_app_settings.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetAppSettings usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetAppSettings(mockInitializationRepository);
  });

  final tLocationUpdateInterval = 0;
  final tLocationUpdateMinDistance = 50;
  final tInfoUpdateInterval = 300;
  final tAppSettings = AppSettings(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);

  test(
    'should return AppSettings when they are available',
    () async {
      // arrange
      when(mockInitializationRepository.getAppSettings())
          .thenAnswer((_) async => Right(tAppSettings));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tAppSettings));
      verify(mockInitializationRepository.getAppSettings());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}