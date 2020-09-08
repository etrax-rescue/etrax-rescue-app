// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../backend/types/missions.dart';
import '../backend/types/user_roles.dart';
import '../backend/types/user_states.dart';
import '../frontend/app_connection/pages/app_connection_page.dart';
import '../frontend/check_requirements/pages/check_requirements_page.dart';
import '../frontend/confirmation/pages/confirmation_page.dart';
import '../frontend/home/pages/home_page.dart';
import '../frontend/launch/pages/launch_page.dart';
import '../frontend/login/pages/login_page.dart';
import '../frontend/missions/pages/mission_page.dart';
import '../frontend/state_update/pages/state_update_page.dart';
import '../frontend/submit_poi/pages/submit_poi_page.dart';

class Routes {
  static const String launchPage = '/';
  static const String appConnectionPage = '/app-connection-page';
  static const String loginPage = '/login-page';
  static const String missionPage = '/mission-page';
  static const String confirmationPage = '/confirmation-page';
  static const String checkRequirementsPage = '/check-requirements-page';
  static const String homePage = '/home-page';
  static const String submitPoiPage = '/submit-poi-page';
  static const String stateUpdatePage = '/state-update-page';
  static const all = <String>{
    launchPage,
    appConnectionPage,
    loginPage,
    missionPage,
    confirmationPage,
    checkRequirementsPage,
    homePage,
    submitPoiPage,
    stateUpdatePage,
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
    RouteDef(Routes.submitPoiPage, page: SubmitPoiPage),
    RouteDef(Routes.stateUpdatePage, page: StateUpdatePage),
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
      final args = data.getArgs<AppConnectionPageArguments>(
        orElse: () => AppConnectionPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            AppConnectionPage(key: args.key).wrappedRoute(context),
        settings: data,
      );
    },
    LoginPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginPage().wrappedRoute(context),
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
      final args = data.getArgs<ConfirmationPageArguments>(nullOk: false);
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
      final args = data.getArgs<CheckRequirementsPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CheckRequirementsPage(
          key: args.key,
          state: args.state,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    HomePage: (data) {
      final args = data.getArgs<HomePageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomePage(
          key: args.key,
          state: args.state,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    SubmitPoiPage: (data) {
      final args = data.getArgs<SubmitPoiPageArguments>(
        orElse: () => SubmitPoiPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            SubmitPoiPage(key: args.key).wrappedRoute(context),
        settings: data,
      );
    },
    StateUpdatePage: (data) {
      final args = data.getArgs<StateUpdatePageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => StateUpdatePage(
          key: args.key,
          currentState: args.currentState,
        ).wrappedRoute(context),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// AppConnectionPage arguments holder class
class AppConnectionPageArguments {
  final Key key;
  AppConnectionPageArguments({this.key});
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

/// SubmitPoiPage arguments holder class
class SubmitPoiPageArguments {
  final Key key;
  SubmitPoiPageArguments({this.key});
}

/// StateUpdatePage arguments holder class
class StateUpdatePageArguments {
  final Key key;
  final UserState currentState;
  StateUpdatePageArguments({this.key, @required this.currentState});
}
