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
import '../frontend/authentication/pages/login_page.dart';
import '../frontend/home/pages/home_page.dart';
import '../frontend/home/pages/photo_page.dart';
import '../frontend/initialization/pages/confirmation_page.dart';
import '../frontend/initialization/pages/initialization_page.dart';
import '../frontend/update_state/pages/update_state_page.dart';

class Routes {
  static const String appConnectionPage = '/';
  static const String loginPage = '/login-page';
  static const String missionPage = '/mission-page';
  static const String confirmationPage = '/confirmation-page';
  static const String homePage = '/home-page';
  static const String submitImagePage = '/submit-image-page';
  static const String updateStatePage = '/update-state-page';
  static const all = <String>{
    appConnectionPage,
    loginPage,
    missionPage,
    confirmationPage,
    homePage,
    submitImagePage,
    updateStatePage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.appConnectionPage, page: AppConnectionPage),
    RouteDef(Routes.loginPage, page: LoginPage),
    RouteDef(Routes.missionPage, page: MissionPage),
    RouteDef(Routes.confirmationPage, page: ConfirmationPage),
    RouteDef(Routes.homePage, page: HomePage),
    RouteDef(Routes.submitImagePage, page: SubmitImagePage),
    RouteDef(Routes.updateStatePage, page: UpdateStatePage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    AppConnectionPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AppConnectionPage(),
        settings: data,
      );
    },
    LoginPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginPage(),
        settings: data,
      );
    },
    MissionPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MissionPage(),
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
        ),
        settings: data,
      );
    },
    HomePage: (data) {
      var args = data.getArgs<HomePageArguments>(
        orElse: () => HomePageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomePage(key: args.key),
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
        builder: (context) => UpdateStatePage(
          key: args.key,
          initial: args.initial,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

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

/// HomePage arguments holder class
class HomePageArguments {
  final Key key;
  HomePageArguments({this.key});
}

/// SubmitImagePage arguments holder class
class SubmitImagePageArguments {
  final Key key;
  SubmitImagePageArguments({this.key});
}

/// UpdateStatePage arguments holder class
class UpdateStatePageArguments {
  final Key key;
  final bool initial;
  UpdateStatePageArguments({this.key, this.initial = false});
}
