import 'package:etrax_rescue_app/backend/types/app_configuration.dart';
import 'package:etrax_rescue_app/backend/types/app_connection.dart';
import 'package:etrax_rescue_app/backend/types/authentication_data.dart';
import 'package:etrax_rescue_app/backend/types/initialization_data.dart';
import 'package:etrax_rescue_app/backend/types/missions.dart';
import 'package:etrax_rescue_app/backend/types/organizations.dart';
import 'package:etrax_rescue_app/backend/types/quick_actions.dart';
import 'package:etrax_rescue_app/backend/types/search_area.dart';
import 'package:etrax_rescue_app/backend/types/user_roles.dart';
import 'package:etrax_rescue_app/backend/types/user_states.dart';

import 'package:latlong/latlong.dart';

// Generic Types
final tDate = DateTime.utc(2020, 2, 2, 20, 20, 2, 20);

// App Connection
final tHost = 'https://apptest.etrax.at';
final tBasePath = 'subdir';
final tAppConnection = AppConnection(host: tHost, basePath: tBasePath);

// Authorization Data
final tOrganizationID = 'DEV';
final tUsername = 'JohnDoe';
final tToken = '0123456789ABCDEF';
final tIssuingDate = tDate;
final tAuthenticationData = AuthenticationData(
    organizationID: tOrganizationID,
    username: tUsername,
    token: tToken,
    issuingDate: tIssuingDate);

final tPassword = '0123456789ABCDEF';

// Organization Collection
final tOrganizationName = 'Rettungshunde';
final tOrganization =
    Organization(id: tOrganizationID, name: tOrganizationName);
final tOrganizationCollection =
    OrganizationCollection(organizations: <Organization>[tOrganization]);

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
final tMissionName = 'Wien';
final tMissionStart = tDate;
final tLatitude = 48.2084114;
final tLongitude = 16.3712767;
final tMissionExercise = true;
final tMission = Mission(
  id: tMissionID,
  name: tMissionName,
  start: tMissionStart,
  latitude: tLatitude,
  longitude: tLongitude,
  exercise: tMissionExercise,
);
final tMissionCollection = MissionCollection(missions: <Mission>[tMission]);

// UserStateCollection
final tUserStateID = 42;
final tUserStateName = 'approaching';
final tUserStateDescription = 'is on their way';
final tUserStateLocationAccuracy = 2;
final tUserState = UserState(
    id: tUserStateID,
    name: tUserStateName,
    description: tUserStateDescription,
    locationAccuracy: tUserStateLocationAccuracy);
final tUserStateCollection =
    UserStateCollection(states: <UserState>[tUserState]);

// UserRoleCollection
final tUserRoleID = 42;
final tUserRoleName = 'operator';
final tUserRoleDescription = 'the one who does stuff';
final tUserRole = UserRole(
    id: tUserRoleID, name: tUserRoleName, description: tUserRoleDescription);
final tUserRoleCollection = UserRoleCollection(roles: <UserRole>[tUserRole]);

// QuickActionCollection
final tQuickActionCollection = QuickActionCollection(actions: [tUserState]);

// InitializationData
final tInitializationData = InitializationData(
  appConfiguration: tAppConfiguration,
  missionCollection: tMissionCollection,
  userStateCollection: tUserStateCollection,
  userRoleCollection: tUserRoleCollection,
  quickActionCollection: tQuickActionCollection,
);

// Search Area
final tSearchArea = SearchArea(coordinates: [LatLng(48.2084114, 16.3712767)]);
final tSearchAreaCollection = SearchAreaCollection(areas: [tSearchArea]);
