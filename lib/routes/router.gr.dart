// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/app_connect/presentation/pages/app_connect_page.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/pages/login_page.dart';

class Routes {
  static const String appconnectPage = '/';
  static const String loginPage = '/login-page';
  static const all = <String>{
    appconnectPage,
    loginPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.appconnectPage, page: AppconnectPage),
    RouteDef(Routes.loginPage, page: LoginPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    AppconnectPage: (RouteData data) {
      var args = data.getArgs<AppconnectPageArguments>(
          orElse: () => AppconnectPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => AppconnectPage(key: args.key),
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
  };
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//AppconnectPage arguments holder class
class AppconnectPageArguments {
  final Key key;
  AppconnectPageArguments({this.key});
}

//LoginPage arguments holder class
class LoginPageArguments {
  final Key key;
  LoginPageArguments({this.key});
}
