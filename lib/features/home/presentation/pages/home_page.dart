import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/features/home/presentation/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  String title;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    title = _mapIndexToTitle(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: PreferredSize(
          preferredSize: Size(
            double.infinity,
            Theme.of(context).textTheme.bodyText2.fontSize + 4,
          ),
          child: Container(
            color: Theme.of(context).accentColor,
            height: Theme.of(context).textTheme.bodyText2.fontSize + 4,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Text(
                'Status: Anreise',
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
              icon: Icon(Icons.account_circle), title: Text('Info')),
          BottomNavigationBarItem(icon: Icon(Icons.place), title: Text('GPS')),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Karte')),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _pageIndex = index;
            title = _mapIndexToTitle(index);
          });
        },
        currentIndex: _pageIndex,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(child: Icon(Icons.account_circle)),
          Container(child: Icon(Icons.place)),
          MapScreen(),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        backgroundColor: Theme.of(context).accentColor,
        children: [
          SpeedDialChild(
            child: Icon(Icons.exit_to_app),
            backgroundColor: Colors.red,
            label: 'Einsatz verlassen',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: _leaveMission,
          ),
          SpeedDialChild(
            child: Icon(Icons.update),
            backgroundColor: Colors.blue,
            label: 'Status ändern',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: _updateState,
          ),
          SpeedDialChild(
            child: Icon(Icons.add_a_photo),
            backgroundColor: Colors.green,
            label: 'Foto aufnehmen',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: _takePhoto,
          ),
        ],
      ),
    );
  }

  String _mapIndexToTitle(int index) {
    switch (index) {
      case 0:
        return 'Informationen';
      case 1:
        return 'GPS Details';
      case 2:
        return 'Kartenansicht';
      default:
        return 'eTrax|rescue';
    }
  }

  void _leaveMission() {
    ExtendedNavigator.of(context).popAndPush('/mission-page');
  }

  void _updateState() {
    print('update state');
  }

  void _takePhoto() {
    print('take photo');
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(48.2084114, 16.3712767),
        zoom: 12.0,
      ),
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
    );
  }
}
