// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../backend/types/missions.dart';
import '../backend/types/organizations.dart';
import '../backend/types/user_roles.dart';
import '../backend/types/user_states.dart';
import '../frontend/app_connection/pages/app_connection_page.dart';
import '../frontend/confirmation/pages/confirmation_page.dart';
import '../frontend/home/pages/home_page.dart';
import '../frontend/launch/pages/launch_page.dart';
import '../frontend/login/pages/login_page.dart';
import '../frontend/missions/pages/mission_page.dart';
import '../frontend/submit_image/pages/submit_image_page.dart';
import '../frontend/update_state/pages/check_requirements_page.dart';
import '../frontend/update_state/pages/update_state_page.dart';

class Routes {
  static const String launchPage = '/';
  static const String appConnectionPage = '/app-connection-page';
  static const String loginPage = '/login-page';
  static const String missionPage = '/mission-page';
  static const String confirmationPage = '/confirmation-page';
  static const String checkRequirementsPage = '/check-requirements-page';
  static const String homePage = '/home-page';
  static const String submitImagePage = '/submit-image-page';
  static const String updateStatePage = '/update-state-page';
  static const all = <String>{
    launchPage,
    appConnectionPage,
    loginPage,
    missionPage,
    confirmationPage,
    checkRequirementsPage,
    homePage,
    submitImagePage,
    updateStatePage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.launchPage, page: LaunchPage),
    RouteDef(Routes.appConnectionPage, page: AppConnectionPage),
    RouteDef(Routes.loginPage, page: LoginPage),
    RouteDef(Routes.missionPage, page: MissionPage),
    RouteDef(Routes.confirmationPage, page: ConfirmationPage),
    RouteDef(Routes.checkRequirementsPage, page: CheckRequirementsPage),
    RouteDef(Routes.homePage, page: HomePage),
    RouteDef(Routes.submitImagePage, page: SubmitImagePage),
    RouteDef(Routes.updateStatePage, page: UpdateStatePage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LaunchPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LaunchPage().wrappedRoute(context),
        settings: data,
      );
    },
    AppConnectionPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AppConnectionPage().wrappedRoute(context),
        settings: data,
      );
    },
    LoginPage: (data) {
      var args = data.getArgs<LoginPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginPage(
          key: args.key,
          organizations: args.organizations,
          username: args.username,
          organizationID: args.organizationID,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    MissionPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MissionPage().wrappedRoute(context),
        settings: data,
      );
    },
    ConfirmationPage: (data) {
      var args = data.getArgs<ConfirmationPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmationPage(
          key: args.key,
          mission: args.mission,
          roles: args.roles,
          states: args.states,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    CheckRequirementsPage: (data) {
      var args = data.getArgs<CheckRequirementsPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CheckRequirementsPage(
          key: args.key,
          state: args.state,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    HomePage: (data) {
      var args = data.getArgs<HomePageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomePage(
          key: args.key,
          state: args.state,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    SubmitImagePage: (data) {
      var args = data.getArgs<SubmitImagePageArguments>(
        orElse: () => SubmitImagePageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SubmitImagePage(key: args.key),
        settings: data,
      );
    },
    UpdateStatePage: (data) {
      var args = data.getArgs<UpdateStatePageArguments>(
        orElse: () => UpdateStatePageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => UpdateStatePage(key: args.key),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginPage arguments holder class
class LoginPageArguments {
  final Key key;
  final OrganizationCollection organizations;
  final String username;
  final String organizationID;
  LoginPageArguments(
      {this.key,
      @required this.organizations,
      @required this.username,
      @required this.organizationID});
}

/// ConfirmationPage arguments holder class
class ConfirmationPageArguments {
  final Key key;
  final Mission mission;
  final UserRoleCollection roles;
  final UserStateCollection states;
  ConfirmationPageArguments(
      {this.key,
      @required this.mission,
      @required this.roles,
      @required this.states});
}

/// CheckRequirementsPage arguments holder class
class CheckRequirementsPageArguments {
  final Key key;
  final UserState state;
  CheckRequirementsPageArguments({this.key, @required this.state});
}

/// HomePage arguments holder class
class HomePageArguments {
  final Key key;
  final UserState state;
  HomePageArguments({this.key, @required this.state});
}

/// SubmitImagePage arguments holder class
class SubmitImagePageArguments {
  final Key key;
  SubmitImagePageArguments({this.key});
}

/// UpdateStatePage arguments holder class
class UpdateStatePageArguments {
  final Key key;
  UpdateStatePageArguments({this.key});
}
