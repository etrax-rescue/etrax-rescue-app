// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/app_connection/presentation/pages/app_connection_page.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/pages/login_page.dart';
import 'package:etrax_rescue_app/features/initialization/presentation/pages/initialization_page.dart';

class Routes {
  static const String appConnectionPage = '/';
  static const String loginPage = '/login-page';
  static const String missionPage = '/mission-page';
  static const all = <String>{
    appConnectionPage,
    loginPage,
    missionPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.appConnectionPage, page: AppConnectionPage),
    RouteDef(Routes.loginPage, page: LoginPage),
    RouteDef(Routes.missionPage, page: MissionPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    AppConnectionPage: (RouteData data) {
      var args = data.getArgs<AppConnectionPageArguments>(
          orElse: () => AppConnectionPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => AppConnectionPage(key: args.key),
        settings: data,
      );
    },
    LoginPage: (RouteData data) {
      var args =
          data.getArgs<LoginPageArguments>(orElse: () => LoginPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginPage(key: args.key),
        settings: data,
      );
    },
    MissionPage: (RouteData data) {
      var args = data.getArgs<MissionPageArguments>(
          orElse: () => MissionPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => MissionPage(key: args.key),
        settings: data,
      );
    },
  };
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//AppConnectionPage arguments holder class
class AppConnectionPageArguments {
  final Key key;
  AppConnectionPageArguments({this.key});
}

//LoginPage arguments holder class
class LoginPageArguments {
  final Key key;
  LoginPageArguments({this.key});
}

//MissionPage arguments holder class
class MissionPageArguments {
  final Key key;
  MissionPageArguments({this.key});
}
