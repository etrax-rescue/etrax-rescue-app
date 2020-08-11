import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = 'Informationen';

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
          child: InkWell(
            onTap: () {
              print('tapped!');
            },
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
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          onTap: (int index) {
            setState(() {
              title = _mapIndexToTitle(index);
            });
          },
          tabs: [
            Tab(icon: Icon(Icons.account_circle)),
            Tab(icon: Icon(Icons.place)),
            Tab(icon: Icon(Icons.map)),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Icon(Icons.account_circle),
          Icon(Icons.place),
          Icon(Icons.map),
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
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
              child: Icon(Icons.add_a_photo),
              backgroundColor: Colors.green,
              label: 'Foto aufnehmen',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIRST CHILD')),
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
}
