import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
import 'package:etrax_rescue_app/features/initialization/domain/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/features/initialization/domain/usecases/get_missions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetMissions usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetMissions(mockInitializationRepository);
  });

  final tMissionID = '0123456789ABCDEF';
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
  final tMissions = Missions(missions: <Mission>[tMission]);

  test(
    'should return Missions',
    () async {
      // arrange
      when(mockInitializationRepository.getMissions())
          .thenAnswer((_) async => Right(tMissions));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tMissions));
      verify(mockInitializationRepository.getMissions());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}