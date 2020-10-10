import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_missions.dart';

import '../../reference_types.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetMissions usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetMissions(mockInitializationRepository);
  });

  test(
    'should return Missions',
    () async {
      // arrange
      when(mockInitializationRepository.getMissions())
          .thenAnswer((_) async => Right(tMissionCollection));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tMissionCollection));
      verify(mockInitializationRepository.getMissions());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
