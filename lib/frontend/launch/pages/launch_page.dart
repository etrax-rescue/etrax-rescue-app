import 'package:auto_route/auto_route.dart';
import '../../widgets/width_limiter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../bloc/launch_bloc.dart';

class LaunchPage extends StatelessWidget implements AutoRouteWrapper {
  const LaunchPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
        data: themeData[AppTheme.LightStatusBar],
        child: BlocProvider(
            create: (_) => sl<LaunchBloc>()..add(Launch()), child: this));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LaunchBloc, LaunchState>(
        listener: (context, state) {
          print(state);
          if (state is LaunchAppConnectionPage) {
            ExtendedNavigator.of(context).popAndPush(Routes.appConnectionPage);
          } else if (state is LaunchLoginPage) {
            ExtendedNavigator.of(context).popAndPush(Routes.loginPage);
          } else if (state is LaunchHomePage) {
            ExtendedNavigator.of(context).popAndPush(Routes.homePage,
                arguments: HomePageArguments(state: state.missionState.state));
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            physics: RangeMaintainingScrollPhysics()
                .applyTo(AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                expandedHeight: MediaQuery.of(context).size.height / 3,
                flexibleSpace: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Image(
                      image: AssetImage('assets/images/etrax_rescue_logo.png'),
                      width: 200,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: WidthLimiter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
