import 'package:auto_route/auto_route_annotations.dart';

import '../features/app_connection/presentation/pages/app_connection_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/initialization/presentation/pages/initialization_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: AppConnectionPage, initial: true),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: InitializationPage),
  ],
)
class $Router {}
