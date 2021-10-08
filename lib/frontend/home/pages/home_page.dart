// @dart=2.9
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial_quickaction/flutter_speed_dial.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../../backend/types/quick_actions.dart';
import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../check_requirements/cubit/check_requirements_cubit.dart';
import '../../widgets/about_menu_entry.dart';
import '../../widgets/popup_menu.dart';
import '../bloc/home_bloc.dart';
import '../widgets/details_screen.dart';
import '../widgets/gps_screen.dart';
import '../widgets/map_screen.dart';
import '../widgets/quick_action_box.dart';

class HomePage extends StatefulWidget implements AutoRouteWrapper {
  HomePage({Key key, @required this.state}) : super(key: key);

  final UserState state;

  @override
  _HomePageState createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
      data: AppThemeData.DarkStatusBar,
      child: BlocProvider<HomeBloc>(
          lazy: false,
          create: (_) => sl<HomeBloc>()..add(Startup(userState: state)),
          child: this),
    );
  }
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  PreloadPageController _pageController;
  String _title;
  int _pageIndex = 0;
  List<SpeedDialChild> _speedDials = [];
  QuickActionCollection _quickActions = QuickActionCollection(actions: []);

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController(initialPage: _pageIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _speedDials = _buildSpeedDials();
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check for new locations that were recorded while the app was in the background
      context.read<HomeBloc>().add(CheckStatus());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<SpeedDialChild> _buildSpeedDials() {
    final speedDials = [
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

    if (widget.state.locationAccuracy >= 2) {
      speedDials.add(SpeedDialChild(
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.green,
        label: S.of(context).TAKE_PHOTO,
        labelStyle: TextStyle(fontSize: 18.0),
        onTap: _takePhoto,
      ));
    }

    return speedDials;
  }

  @override
  Widget build(BuildContext context) {
    _title = _mapIndexToTitle(_pageIndex);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.renewStatus) {
          AutoRouter.of(context).popAndPush(
            CheckRequirementsPageRoute(
              currentState: widget.state,
              desiredState: widget.state,
              action: StatusAction.refresh,
            ),
          );
        }
        if (state.quickActions.actions.length > 0) {
          setState(() {
            _quickActions = state.quickActions;
            _speedDials = _buildSpeedDials();
          });
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
            PopupMenu(actions: {0: generateAboutMenuEntry(context)}),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: S.of(context).HEADING_INFO_SHORT),
            BottomNavigationBarItem(
                icon: Icon(Icons.map), label: S.of(context).HEADING_MAP_SHORT),
            BottomNavigationBarItem(
                icon: Icon(Icons.place),
                label: S.of(context).HEADING_GPS_SHORT),
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
          quickActionWidget: QuickActionsBox(actions: _quickActions),
          maxHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom +
              40 -
              kBottomNavigationBarHeight,
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).LEAVE_MISSION),
          content: Text(S.of(context).CONFIRM_LEAVE_MISSION),
          actions: [
            TextButton(
              child: Text(S.of(context).CANCEL),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).YES),
              onPressed: () {
                AutoRouter.of(context).pushAndPopUntil(
                  CheckRequirementsPageRoute(
                    desiredState: widget.state,
                    currentState: widget.state,
                    action: StatusAction.logout,
                  ),
                  predicate: (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _updateState() {
    AutoRouter.of(context).push(
      StateUpdatePageRoute(currentState: widget.state),
    );
  }

  void _takePhoto() async {
    AutoRouter.of(context).push(SubmitPoiPageRoute());
  }
}
