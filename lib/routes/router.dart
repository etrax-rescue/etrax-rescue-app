import 'package:auto_route/auto_route_annotations.dart';

import '../features/link/presentation/pages/link_app_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: LinkAppPage, initial: true),
    MaterialRoute(page: LoginPage),
  ],
)
class $Router {}
