import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../../backend/types/user_states.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../bloc/home_bloc.dart';
import '../widgets/popup_menu.dart';

class HomePage extends StatefulWidget implements AutoRouteWrapper {
  final UserState state;

  HomePage({Key key, @required this.state}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<HomeBloc>(create: (_) => sl(), child: this);
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PreloadPageController _pageController;
  String _title;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The title cannot be updated in the initState function because the
    // localization needs a complete build context which is not available at
    // that point in time. That's the reason why it's done here.
    _title = _mapIndexToTitle(_pageIndex);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is LeftMission) {
          ExtendedNavigator.of(context).popAndPush(Routes.launchPage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
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
            HomePopupMenu(callback: () {
              print('Opening settings');
            }),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text(S.of(context).HEADING_INFO_SHORT)),
            BottomNavigationBarItem(
                icon: Icon(Icons.place),
                title: Text(S.of(context).HEADING_GPS_SHORT)),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text(S.of(context).HEADING_MAP_SHORT)),
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
                return Container(child: Icon(Icons.account_circle));
              case 1:
                return GPSScreen();
              case 2:
                return MapScreen();
            }
            return Container();
          },
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Theme.of(context).accentColor,
          children: [
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
            ),
            SpeedDialChild(
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.green,
              label: S.of(context).TAKE_PHOTO,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: _takePhoto,
            ),
          ],
        ),
      ),
    );
  }

  String _mapIndexToTitle(int index) {
    switch (index) {
      case 0:
        return S.of(context).HEADING_INFO;
      case 1:
        return S.of(context).HEADING_GPS;
      case 2:
        return S.of(context).HEADING_MAP;
      default:
        return S.of(context).APP_NAME;
    }
  }

  void _leaveMission() {
    BlocProvider.of<HomeBloc>(context).add(LeaveMission());
  }

  void _updateState() {
    ExtendedNavigator.of(context).push(Routes.stateUpdatePage,
        arguments: StateUpdatePageArguments(currentState: widget.state));
  }

  void _takePhoto() async {
    ExtendedNavigator.of(context).push(Routes.submitImagePage);
  }
}

class GPSScreen extends StatefulWidget {
  GPSScreen({Key key}) : super(key: key);

  @override
  _GPSScreenState createState() => _GPSScreenState();
}

class _GPSScreenState extends State<GPSScreen> {
  Stream<LocationData> _locationStream;

  @override
  Widget build(BuildContext context) {
    return Container(
        /*child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is ConnectLocationStreamSuccess) {}
        SingleChildScrollView(
          child: StreamBuilder<LocationData>(
            stream: _locationStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error occured');
              } else if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return LocationDataWidget(locationData: snapshot.data);
            },
          ),
        );
      }),*/
        );
  }
}

class LocationDataWidget extends StatelessWidget {
  const LocationDataWidget({this.locationData});
  final LocationData locationData;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(locationData.time.toInt());
    return Container(
      child: Column(children: <Widget>[
        DataEntry(label: 'Datetime', data: '$dateTime'),
        DataEntry(label: 'Latitude', data: '${locationData.latitude}'),
        DataEntry(label: 'Longitude', data: '${locationData.longitude}'),
        DataEntry(label: 'Accuracy', data: '${locationData.accuracy}'),
        DataEntry(label: 'Altitude', data: '${locationData.altitude}'),
        DataEntry(label: 'Speed', data: '${locationData.speed}'),
        DataEntry(
            label: 'Speed Accuracy', data: '${locationData.speedAccuracy}'),
        DataEntry(label: 'Heading', data: '${locationData.heading}'),
      ]),
    );
  }
}

class DataEntry extends StatelessWidget {
  const DataEntry({this.label, this.data});
  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(data, style: TextStyle(color: Colors.grey))
          ]),
    );
  }
}

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlutterMap(
          key: _key,
          options: MapOptions(
            center: LatLng(48.2084114, 16.3712767),
            zoom: 12.0,
          ),
          mapController: _mapController,
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              tileProvider: CachedNetworkTileProvider(),
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(48.2084114, 16.3712767),
                  builder: (ctx) => Container(
                    child: Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: Icon(Icons.layers, color: Colors.grey),
              onPressed: () {
                print('layer selection...');
              },
            ),
          ),
        ),
      ],
    );
  }
}
