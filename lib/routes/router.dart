import 'package:auto_route/auto_route_annotations.dart';
import 'package:etrax_rescue_app/features/home/presentation/pages/home_page.dart';
import 'package:etrax_rescue_app/features/initialization/presentation/pages/confirmation_page.dart';

import '../features/app_connection/presentation/pages/app_connection_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/initialization/presentation/pages/initialization_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: AppConnectionPage, initial: true),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: MissionPage),
    MaterialRoute(page: ConfirmationPage),
    MaterialRoute(page: HomePage),
  ],
)
class $Router {}
