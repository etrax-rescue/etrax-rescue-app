// @dart=2.9
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/foundation.dart' as _i12;
import 'package:flutter/material.dart' as _i11;

import '../backend/types/missions.dart' as _i13;
import '../backend/types/user_roles.dart' as _i14;
import '../backend/types/user_states.dart' as _i15;
import '../frontend/app_connection/pages/app_connection_page.dart' as _i2;
import '../frontend/check_requirements/cubit/check_requirements_cubit.dart'
    as _i16;
import '../frontend/check_requirements/pages/check_requirements_page.dart'
    as _i6;
import '../frontend/confirmation/pages/confirmation_page.dart' as _i5;
import '../frontend/home/pages/home_page.dart' as _i7;
import '../frontend/launch/pages/launch_page.dart' as _i1;
import '../frontend/login/pages/login_page.dart' as _i3;
import '../frontend/missions/pages/mission_page.dart' as _i4;
import '../frontend/state_update/pages/state_update_page.dart' as _i9;
import '../frontend/submit_poi/pages/submit_poi_page.dart' as _i8;

class Router extends _i10.RootStackRouter {
  Router([_i11.GlobalKey<_i11.NavigatorState> navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    LaunchPageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.LaunchPage());
    },
    AppConnectionPageRoute.name: (routeData) {
      final args = routeData.argsAs<AppConnectionPageRouteArgs>(
          orElse: () => const AppConnectionPageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.AppConnectionPage(key: args.key),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    LoginPageRoute.name: (routeData) {
      final args = routeData.argsAs<LoginPageRouteArgs>(
          orElse: () => const LoginPageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.LoginPage(key: args.key),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    MissionPageRoute.name: (routeData) {
      final args = routeData.argsAs<MissionPageRouteArgs>(
          orElse: () => const MissionPageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.MissionPage(key: args.key),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    ConfirmationPageRoute.name: (routeData) {
      final args = routeData.argsAs<ConfirmationPageRouteArgs>(
          orElse: () => const ConfirmationPageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i5.ConfirmationPage(
              mission: args.mission, roles: args.roles, states: args.states),
          transitionsBuilder: _i10.TransitionsBuilders.slideLeftWithFade,
          durationInMilliseconds: 300,
          opaque: true,
          barrierDismissible: false);
    },
    CheckRequirementsPageRoute.name: (routeData) {
      final args = routeData.argsAs<CheckRequirementsPageRouteArgs>(
          orElse: () => const CheckRequirementsPageRouteArgs());
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.CheckRequirementsPage(
              key: args.key,
              desiredState: args.desiredState,
              currentState: args.currentState,
              action: args.action));
    },
    HomePageRoute.name: (routeData) {
      final args = routeData.argsAs<HomePageRouteArgs>(
          orElse: () => const HomePageRouteArgs());
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.HomePage(key: args.key, state: args.state));
    },
    SubmitPoiPageRoute.name: (routeData) {
      final args = routeData.argsAs<SubmitPoiPageRouteArgs>(
          orElse: () => const SubmitPoiPageRouteArgs());
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.SubmitPoiPage(key: args.key));
    },
    StateUpdatePageRoute.name: (routeData) {
      final args = routeData.argsAs<StateUpdatePageRouteArgs>(
          orElse: () => const StateUpdatePageRouteArgs());
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.StateUpdatePage(
              key: args.key, currentState: args.currentState));
    }
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(LaunchPageRoute.name, path: '/'),
        _i10.RouteConfig(AppConnectionPageRoute.name,
            path: '/app-connection-page'),
        _i10.RouteConfig(LoginPageRoute.name, path: '/login-page'),
        _i10.RouteConfig(MissionPageRoute.name, path: '/mission-page'),
        _i10.RouteConfig(ConfirmationPageRoute.name,
            path: '/confirmation-page'),
        _i10.RouteConfig(CheckRequirementsPageRoute.name,
            path: '/check-requirements-page'),
        _i10.RouteConfig(HomePageRoute.name, path: '/home-page'),
        _i10.RouteConfig(SubmitPoiPageRoute.name, path: '/submit-poi-page'),
        _i10.RouteConfig(StateUpdatePageRoute.name, path: '/state-update-page')
      ];
}

/// generated route for [_i1.LaunchPage]
class LaunchPageRoute extends _i10.PageRouteInfo<void> {
  const LaunchPageRoute() : super(name, path: '/');

  static const String name = 'LaunchPageRoute';
}

/// generated route for [_i2.AppConnectionPage]
class AppConnectionPageRoute
    extends _i10.PageRouteInfo<AppConnectionPageRouteArgs> {
  AppConnectionPageRoute({_i12.Key key})
      : super(name,
            path: '/app-connection-page',
            args: AppConnectionPageRouteArgs(key: key));

  static const String name = 'AppConnectionPageRoute';
}

class AppConnectionPageRouteArgs {
  const AppConnectionPageRouteArgs({this.key});

  final _i12.Key key;
}

/// generated route for [_i3.LoginPage]
class LoginPageRoute extends _i10.PageRouteInfo<LoginPageRouteArgs> {
  LoginPageRoute({_i12.Key key})
      : super(name, path: '/login-page', args: LoginPageRouteArgs(key: key));

  static const String name = 'LoginPageRoute';
}

class LoginPageRouteArgs {
  const LoginPageRouteArgs({this.key});

  final _i12.Key key;
}

/// generated route for [_i4.MissionPage]
class MissionPageRoute extends _i10.PageRouteInfo<MissionPageRouteArgs> {
  MissionPageRoute({_i12.Key key})
      : super(name,
            path: '/mission-page', args: MissionPageRouteArgs(key: key));

  static const String name = 'MissionPageRoute';
}

class MissionPageRouteArgs {
  const MissionPageRouteArgs({this.key});

  final _i12.Key key;
}

/// generated route for [_i5.ConfirmationPage]
class ConfirmationPageRoute
    extends _i10.PageRouteInfo<ConfirmationPageRouteArgs> {
  ConfirmationPageRoute(
      {_i13.Mission mission,
      _i14.UserRoleCollection roles,
      _i15.UserStateCollection states})
      : super(name,
            path: '/confirmation-page',
            args: ConfirmationPageRouteArgs(
                mission: mission, roles: roles, states: states));

  static const String name = 'ConfirmationPageRoute';
}

class ConfirmationPageRouteArgs {
  const ConfirmationPageRouteArgs({this.mission, this.roles, this.states});

  final _i13.Mission mission;

  final _i14.UserRoleCollection roles;

  final _i15.UserStateCollection states;
}

/// generated route for [_i6.CheckRequirementsPage]
class CheckRequirementsPageRoute
    extends _i10.PageRouteInfo<CheckRequirementsPageRouteArgs> {
  CheckRequirementsPageRoute(
      {_i12.Key key,
      _i15.UserState desiredState,
      _i15.UserState currentState,
      _i16.StatusAction action = _i16.StatusAction.change})
      : super(name,
            path: '/check-requirements-page',
            args: CheckRequirementsPageRouteArgs(
                key: key,
                desiredState: desiredState,
                currentState: currentState,
                action: action));

  static const String name = 'CheckRequirementsPageRoute';
}

class CheckRequirementsPageRouteArgs {
  const CheckRequirementsPageRouteArgs(
      {this.key,
      this.desiredState,
      this.currentState,
      this.action = _i16.StatusAction.change});

  final _i12.Key key;

  final _i15.UserState desiredState;

  final _i15.UserState currentState;

  final _i16.StatusAction action;
}

/// generated route for [_i7.HomePage]
class HomePageRoute extends _i10.PageRouteInfo<HomePageRouteArgs> {
  HomePageRoute({_i12.Key key, _i15.UserState state})
      : super(name,
            path: '/home-page',
            args: HomePageRouteArgs(key: key, state: state));

  static const String name = 'HomePageRoute';
}

class HomePageRouteArgs {
  const HomePageRouteArgs({this.key, this.state});

  final _i12.Key key;

  final _i15.UserState state;
}

/// generated route for [_i8.SubmitPoiPage]
class SubmitPoiPageRoute extends _i10.PageRouteInfo<SubmitPoiPageRouteArgs> {
  SubmitPoiPageRoute({_i12.Key key})
      : super(name,
            path: '/submit-poi-page', args: SubmitPoiPageRouteArgs(key: key));

  static const String name = 'SubmitPoiPageRoute';
}

class SubmitPoiPageRouteArgs {
  const SubmitPoiPageRouteArgs({this.key});

  final _i12.Key key;
}

/// generated route for [_i9.StateUpdatePage]
class StateUpdatePageRoute
    extends _i10.PageRouteInfo<StateUpdatePageRouteArgs> {
  StateUpdatePageRoute({_i12.Key key, _i15.UserState currentState})
      : super(name,
            path: '/state-update-page',
            args:
                StateUpdatePageRouteArgs(key: key, currentState: currentState));

  static const String name = 'StateUpdatePageRoute';
}

class StateUpdatePageRouteArgs {
  const StateUpdatePageRouteArgs({this.key, this.currentState});

  final _i12.Key key;

  final _i15.UserState currentState;
}
