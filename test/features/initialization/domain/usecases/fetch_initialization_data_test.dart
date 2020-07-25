import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/app_connection.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/missions.dart';
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

  final tAuthority = 'etrax.at';
  final tBasePath = 'appdata';
  final tAppConnection =
      AppConnection(authority: tAuthority, basePath: tBasePath);

  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';
  final tFetchInitializationDataParams = FetchInitializationDataParams(
    appConnection: tAppConnection,
    username: tUsername,
    token: tToken,
  );

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
    'should return MissionCollection when fetching data succeeds',
    () async {
      // arrange
      when(mockInitializationRepository.fetchInitializationData(any, any, any))
          .thenAnswer((_) async => Right(tMissionCollection));
      // act
      final result = await usecase(tFetchInitializationDataParams);
      // assert
      expect(result, Right(tMissionCollection));
      verify(mockInitializationRepository.fetchInitializationData(
          tAppConnection, tUsername, tToken));
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
