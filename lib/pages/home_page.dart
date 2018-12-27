import 'package:flutter/material.dart';

import '../components/place_module.dart';
import '../components/place_dynamic_module.dart';
import '../components/location_module.dart';

class HomePage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return _HomePageState();
    }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceModule(),
    PlaceDynamicModule(),
    LocationModule()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped, // new
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.place),
            title: new Text('Places'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.place),
            title: new Text('Dynamic'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text('Location'),
          ),
        ],
      ),
    );
  }
}
