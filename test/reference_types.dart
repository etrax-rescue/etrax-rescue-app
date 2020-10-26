import 'dart:ui';

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
final tExpirationDate = tDate;
final tAuthenticationData = AuthenticationData(
    organizationID: tOrganizationID,
    username: tUsername,
    token: tToken,
    expirationDate: tExpirationDate);

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

// SearchArea
final tSearchAreaID = 'SID';
final tSearchAreaLabel = 'Test';
final tSearchAreaDescription = 'Suchgebiet';
final tSearchAreaCoordinates = [
  LatLng(48.34271585959392, 16.297574043273926),
  LatLng(48.34371421407914, 16.299269199371334),
  LatLng(48.34539711023241, 16.29566431045532),
  LatLng(48.34475533435577, 16.295814514160153),
  LatLng(48.34475533435577, 16.295814514160153)
];
final tSearchAreaColor = Color(0xFF00FF00);

final tSearchArea = SearchArea(
    id: tSearchAreaID,
    label: tSearchAreaLabel,
    description: tSearchAreaDescription,
    color: tSearchAreaColor,
    coordinates: tSearchAreaCoordinates);

// SearchAreaCollection
final tSearchAreaCollection = SearchAreaCollection(areas: [tSearchArea]);
