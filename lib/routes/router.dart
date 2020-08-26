import 'package:auto_route/auto_route_annotations.dart';

import '../frontend/app_connection/pages/app_connection_page.dart';
import '../frontend/confirmation/pages/confirmation_page.dart';
import '../frontend/home/pages/home_page.dart';
import '../frontend/launch/pages/launch_page.dart';
import '../frontend/login/pages/login_page.dart';
import '../frontend/missions/pages/mission_page.dart';
import '../frontend/submit_image/pages/submit_image_page.dart';
import '../frontend/update_state/pages/check_requirements_page.dart';
import '../frontend/update_state/pages/update_state_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: LaunchPage, initial: true),
    MaterialRoute(page: AppConnectionPage),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: MissionPage),
    MaterialRoute(page: ConfirmationPage),
    MaterialRoute(page: CheckRequirementsPage),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: SubmitImagePage),
    MaterialRoute(page: UpdateStatePage),
  ],
)
class $Router {}
