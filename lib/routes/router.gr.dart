// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/appconnect/presentation/pages/link_app_page.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/pages/login_page.dart';

class Routes {
  static const String linkAppPage = '/';
  static const String loginPage = '/login-page';
  static const all = <String>{
    linkAppPage,
    loginPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.linkAppPage, page: LinkAppPage),
    RouteDef(Routes.loginPage, page: LoginPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LinkAppPage: (RouteData data) {
      var args = data.getArgs<LinkAppPageArguments>(
          orElse: () => LinkAppPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => LinkAppPage(key: args.key),
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

//LinkAppPage arguments holder class
class LinkAppPageArguments {
  final Key key;
  LinkAppPageArguments({this.key});
}

//LoginPage arguments holder class
class LoginPageArguments {
  final Key key;
  LoginPageArguments({this.key});
}
