// @dart=2.9
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../widgets/width_limiter.dart';
import '../bloc/launch_bloc.dart';

class LaunchPage extends StatelessWidget implements AutoRouteWrapper {
  const LaunchPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
        data: AppThemeData.LightStatusBar,
        child: BlocProvider(
            create: (_) => sl<LaunchBloc>()..add(Launch()), child: this));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LaunchBloc, LaunchState>(
        listener: (context, state) {
          if (state is LaunchAppConnectionPage) {
            AutoRouter.of(context).popAndPush(AppConnectionPageRoute());
          } else if (state is LaunchLoginPage) {
            AutoRouter.of(context).popAndPush(LoginPageRoute());
          } else if (state is LaunchHomePage) {
            AutoRouter.of(context)
                .popAndPush(HomePageRoute(state: state.missionState.state));
          } else if (state is LaunchUnecoverableError) {
            AutoRouter.of(context).popAndPush(AppConnectionPageRoute());
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                expandedHeight:
                    max(MediaQuery.of(context).size.height / 3, 150),
                flexibleSpace: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        16, MediaQuery.of(context).padding.top + 8, 16, 16),
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
                    child: BlocBuilder<LaunchBloc, LaunchState>(
                      builder: (context, state) {
                        return CircularProgressIndicator();
                      },
                    ),
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
