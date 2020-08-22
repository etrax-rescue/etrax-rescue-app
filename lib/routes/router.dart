import 'package:auto_route/auto_route_annotations.dart';

import '../frontend/app_connection/pages/app_connection_page.dart';
import '../frontend/authentication/pages/login_page.dart';
import '../frontend/home/presentation/pages/home_page.dart';
import '../frontend/home/presentation/pages/photo_page.dart';
import '../frontend/initialization/pages/confirmation_page.dart';
import '../frontend/initialization/pages/initialization_page.dart';
import '../frontend/update_state/pages/update_state_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: AppConnectionPage, initial: true),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: MissionPage),
    MaterialRoute(page: ConfirmationPage),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: SubmitImagePage),
    MaterialRoute(page: UpdateStatePage),
  ],
)
class $Router {}
