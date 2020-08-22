import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/backend/types/authentication_data.dart';
import '../../../../lib/backend/types/app_configuration.dart';
import '../../../../lib/backend/types/initialization_data.dart';
import '../../../../lib/backend/types/missions.dart';
import '../../../../lib/backend/types/user_roles.dart';
import '../../../../lib/backend/types/user_states.dart';
import '../../../../lib/backend/domain/repositories/initialization_repository.dart';
import '../../../../lib/backend/domain/usecases/fetch_initialization_data.dart';

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

  final tOrganizationID = 'DEV';
  final tUsername = 'JohnDoe';
  final tToken = '0123456789ABCDEF';
  final tAuthenticationData = AuthenticationData(
      organizationID: tOrganizationID, username: tUsername, token: tToken);
  final tFetchInitializationDataParams = FetchInitializationDataParams(
    appConnection: tAppConnection,
    authenticationData: tAuthenticationData,
  );

  // AppConfiguration
  final tLocationUpdateInterval = 0;
  final tLocationUpdateMinDistance = 50;
  final tInfoUpdateInterval = 300;
  final tAppConfiguration = AppConfiguration(
      locationUpdateInterval: tLocationUpdateInterval,
      locationUpdateMinDistance: tLocationUpdateMinDistance,
      infoUpdateInterval: tInfoUpdateInterval);

  // MissionCollection
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

  // UserStateCollection
  final tUserStateID = 42;
  final tUserStateName = 'approaching';
  final tUserStateDescription = 'is on their way';
  final tUserStateLocationAccuracy = 2;
  final tUserStateModel = UserState(
      id: tUserStateID,
      name: tUserStateName,
      description: tUserStateDescription,
      locationAccuracy: tUserStateLocationAccuracy);
  final tUserStateCollection =
      UserStateCollection(states: <UserState>[tUserStateModel]);

  // UserRoleCollection
  final tUserRoleID = 42;
  final tUserRoleName = 'operator';
  final tUserRoleDescription = 'the one who does stuff';
  final tUserRole = UserRole(
      id: tUserRoleID, name: tUserRoleName, description: tUserRoleDescription);
  final tUserRoleCollection = UserRoleCollection(roles: <UserRole>[tUserRole]);

  // InitializationDataModel
  final tInitializationData = InitializationData(
    appConfiguration: tAppConfiguration,
    missionCollection: tMissionCollection,
    userStateCollection: tUserStateCollection,
    userRoleCollection: tUserRoleCollection,
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
