// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/app_connection/presentation/pages/app_connection_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/initialization/domain/entities/missions.dart';
import '../features/initialization/domain/entities/user_roles.dart';
import '../features/initialization/domain/entities/user_states.dart';
import '../features/initialization/presentation/pages/confirmation_page.dart';
import '../features/initialization/presentation/pages/initialization_page.dart';

class Routes {
  static const String appConnectionPage = '/';
  static const String loginPage = '/login-page';
  static const String missionPage = '/mission-page';
  static const String confirmationPage = '/confirmation-page';
  static const String homePage = '/home-page';
  static const all = <String>{
    appConnectionPage,
    loginPage,
    missionPage,
    confirmationPage,
    homePage,
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
