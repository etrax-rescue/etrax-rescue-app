import 'package:auto_route/auto_route_annotations.dart';
import 'package:etrax_rescue_app/features/link/presentation/pages/link_app_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[MaterialRoute(page: LinkAppPage, initial: true)],
)
class $Router {}
