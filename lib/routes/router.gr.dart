// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/app_connection/presentation/pages/app_connection_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/initialization/domain/entities/missions.dart';
import '../features/initialization/presentation/pages/confirmation_page.dart';
import '../features/initialization/presentation/pages/initialization_page.dart';

class Routes {
  static const String appConnectionPage = '/';
  static const String loginPage = '/login-page';
  static const String missionPage = '/mission-page';
  static const String confirmationPage = '/confirmation-page';
  static const all = <String>{
    appConnectionPage,
    loginPage,
    missionPage,
    confirmationPage,
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
      var args = data.getArgs<MissionPageArguments>(
        orElse: () => MissionPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => MissionPage(key: args.key),
        settings: data,
      );
    },
    ConfirmationPage: (data) {
      var args = data.getArgs<ConfirmationPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmationPage(
          key: args.key,
          mission: args.mission,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// MissionPage arguments holder class
class MissionPageArguments {
  final Key key;
  MissionPageArguments({this.key});
}

/// ConfirmationPage arguments holder class
class ConfirmationPageArguments {
  final Key key;
  final Mission mission;
  ConfirmationPageArguments({this.key, @required this.mission});
}
