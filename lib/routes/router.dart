import 'package:auto_route/auto_route_annotations.dart';

import '../features/app_connection/presentation/pages/app_connection_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/photo_page.dart';
import '../features/initialization/presentation/pages/confirmation_page.dart';
import '../features/initialization/presentation/pages/initialization_page.dart';
import '../features/update_state/presentation/pages/update_state_page.dart';

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
