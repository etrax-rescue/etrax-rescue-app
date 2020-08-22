import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/core/types/usecase.dart';
import '../../../../lib/backend/domain/entities/missions.dart';
import '../../../../lib/backend/domain/repositories/initialization_repository.dart';
import '../../../../lib/backend/domain/usecases/get_missions.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetMissions usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetMissions(mockInitializationRepository);
  });

  final tMissionID = 42;
  final tMissionName = 'TestMission';
  final tMissionStart = DateTime.utc(2020, 1, 1);
  final tLatitude = 48.2206635;
  final tLongitude = 16.309849;
  final tMission = Mission(
    id: tMissionID,
    name: tMissionName,
    start: tMissionStart,
    latitude: tLatitude,
    longitude: tLongitude,
  );
  final tMissionCollection = MissionCollection(missions: <Mission>[tMission]);

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