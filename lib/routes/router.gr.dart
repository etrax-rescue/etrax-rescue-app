// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/link/presentation/pages/link_app_page.dart';

class Routes {
  static const String linkAppPage = '/';
  static const all = <String>{
    linkAppPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.linkAppPage, page: LinkAppPage),
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
