import 'package:auto_route/auto_route_annotations.dart';

import '../features/app_connect/presentation/pages/app_connect_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: AppconnectPage, initial: true),
    MaterialRoute(page: LoginPage),
  ],
)
class $Router {}
