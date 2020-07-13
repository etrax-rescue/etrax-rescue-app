import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/app_settings.dart';
import 'package:etrax_rescue_app/features/initialization/domain/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/features/initialization/domain/usecases/get_app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
  final tAppSettings =
      AppSettings(locationUpdateInterval: tLocationUpdateInterval);

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
