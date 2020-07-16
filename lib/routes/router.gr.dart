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
  static const String initializationPage = '/initialization-page';
  static const all = <String>{
    appConnectionPage,
    loginPage,
    initializationPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.appConnectionPage, page: AppConnectionPage),
    RouteDef(Routes.loginPage, page: LoginPage),
    RouteDef(Routes.initializationPage, page: InitializationPage),
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
    InitializationPage: (RouteData data) {
      var args = data.getArgs<InitializationPageArguments>(
          orElse: () => InitializationPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => InitializationPage(key: args.key),
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

//InitializationPage arguments holder class
class InitializationPageArguments {
  final Key key;
  InitializationPageArguments({this.key});
}
