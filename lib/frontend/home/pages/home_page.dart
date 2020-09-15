import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../bloc/home_bloc.dart';
import '../widgets/details_screen.dart';
import '../widgets/gps_screen.dart';
import '../widgets/map_screen.dart';
import '../../widgets/popup_menu.dart';

class HomePage extends StatefulWidget implements AutoRouteWrapper {
  final UserState state;

  HomePage({Key key, @required this.state}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: themeData[AppTheme.DarkStatusBar],
      child: BlocProvider<HomeBloc>(
          create: (_) => sl<HomeBloc>()..add(Startup(userState: state)),
          child: this),
    );
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  PreloadPageController _pageController;
  String _title;
  int _pageIndex = 0;
  List<SpeedDialChild> _speedDials = [];

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController(initialPage: _pageIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speedDials = [
        SpeedDialChild(
          child: Icon(Icons.exit_to_app),
          backgroundColor: Colors.red,
          label: S.of(context).LEAVE_MISSION,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: _leaveMission,
        ),
        SpeedDialChild(
          child: Icon(Icons.update),
          backgroundColor: Colors.blue,
          label: S.of(context).CHANGE_STATUS,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: _updateState,
        )
      ];

      if (widget.state.locationAccuracy >= 3) {
        _speedDials.add(SpeedDialChild(
          child: Icon(Icons.add_a_photo),
          backgroundColor: Colors.green,
          label: S.of(context).TAKE_PHOTO,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: _takePhoto,
        ));
      }
      setState(() {});
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check for new locations that were recorded while the app was in the background
      context.bloc<HomeBloc>().add(LocationUpdate());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _title = _mapIndexToTitle(_pageIndex);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.closed) {
          ExtendedNavigator.of(context).popAndPush(Routes.launchPage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size(
              double.infinity,
              Theme.of(context).textTheme.bodyText2.fontSize + 8,
            ),
            child: Container(
              color: Theme.of(context).accentColor,
              height: Theme.of(context).textTheme.bodyText2.fontSize + 8,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Text(
                  S.of(context).STATUS_DISPLAY + widget.state.name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            PopupMenu(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text(S.of(context).HEADING_INFO_SHORT)),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text(S.of(context).HEADING_MAP_SHORT)),
            BottomNavigationBarItem(
                icon: Icon(Icons.place),
                title: Text(S.of(context).HEADING_GPS_SHORT)),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              _pageIndex = index;
            });
          },
          currentIndex: _pageIndex,
        ),
        body: PreloadPageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          preloadPagesCount: 3,
          itemBuilder: (BuildContext context, int position) {
            switch (position) {
              case 0:
                return DetailsScreen();
              case 1:
                return MapScreen();
              case 2:
                return GPSScreen();
            }
            return Container();
          },
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Theme.of(context).accentColor,
          children: _speedDials,
        ),
      ),
    );
  }

  String _mapIndexToTitle(int index) {
    switch (index) {
      case 0:
        return S.of(context).HEADING_INFO;
      case 1:
        return S.of(context).HEADING_MAP;
      case 2:
        return S.of(context).HEADING_GPS;
      default:
        return S.of(context).APP_NAME;
    }
  }

  void _leaveMission() {
    BlocProvider.of<HomeBloc>(context).add(Shutdown());
  }

  void _updateState() {
    ExtendedNavigator.of(context).push(Routes.stateUpdatePage,
        arguments: StateUpdatePageArguments(currentState: widget.state));
  }

  void _takePhoto() async {
    ExtendedNavigator.of(context).push(Routes.submitPoiPage);
  }
}
