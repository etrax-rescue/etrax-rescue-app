import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';

import '../frontend/app_connection/pages/app_connection_page.dart';
import '../frontend/check_requirements/pages/check_requirements_page.dart';
import '../frontend/confirmation/pages/confirmation_page.dart';
import '../frontend/home/pages/home_page.dart';
import '../frontend/launch/pages/launch_page.dart';
import '../frontend/login/pages/login_page.dart';
import '../frontend/missions/pages/mission_page.dart';
import '../frontend/state_update/pages/state_update_page.dart';
import '../frontend/submit_poi/pages/submit_poi_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: LaunchPage, initial: true),
    CustomRoute(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 300,
        page: AppConnectionPage),
    CustomRoute(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 300,
        page: LoginPage),
    CustomRoute(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 300,
        page: MissionPage),
    CustomRoute(
        transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        durationInMilliseconds: 300,
        page: ConfirmationPage),
    MaterialRoute(page: CheckRequirementsPage),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: SubmitPoiPage),
    MaterialRoute(page: StateUpdatePage),
  ],
)
class $Router {}
