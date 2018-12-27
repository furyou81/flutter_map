import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart' as geoloc;

import '../keys.dart';

class LocationModule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationModuleState();
  }
}

class _LocationModuleState extends State<LocationModule> {
  var _currentLocation = <String, double>{};
  Uri _staticMapUri;

  void _getStaticMap(double lat, double lng) async {
    final StaticMapProvider staticMapProvider =
        StaticMapProvider(API_KEY);
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', lat, lng)],
        center: Location(lat, lng),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    setState(() {
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() async {
    final location = geoloc.Location();
    try {
      var currentLocation = await location.getLocation();
      print('${currentLocation['latitude']} ${currentLocation['longitude']}');
      _getStaticMap(currentLocation['latitude'], currentLocation['longitude']);
    } catch (err) {
      print(err);
      _currentLocation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Current location: $_currentLocation'),
        RaisedButton(
          onPressed: _updateLocation,
          child: Text('Update location'),
        ),
        SizedBox(
          height: 10.0,
        ),
        _staticMapUri != null
            ? Image.network(_staticMapUri.toString())
            : Text('Nothing to display'),
      ],
    );
  }
}
