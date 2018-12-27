import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart' as mapView;
import 'package:location/location.dart' as geoloc;
import "package:google_maps_webservice/places.dart" as places;

import '../keys.dart';

class PlaceDynamicModule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaceDynamicModuleState();
  }
}

class _PlaceDynamicModuleState extends State<PlaceDynamicModule> {
  final mapView.MapView _mapView = mapView.MapView();
  var _currentLocation = <String, double>{};
  final places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
      apiKey: API_KEY);

  void _updateMarkers(List<places.PlacesSearchResult> results) {
    print("UPDATING RESTAURANT");
    print(results);
    var markers = results
        .map((r) => mapView.Marker(
            r.id, r.name, r.geometry.location.lat, r.geometry.location.lng))
        .toList();
    // gettint the current markers
    var currentMarkers = _mapView.markers;

    var markersToRemove =
        currentMarkers.where((m) => !markers.contains(m));
    var markersToAdd =
        markers.where((m) => !currentMarkers.contains(m));
    markersToRemove.forEach((m) => _mapView.removeMarker(m));
    markersToAdd.forEach((m) => _mapView.addMarker(m));
  }

  Future _findRestaurantsAround() async {
    // find the center of the current map
    mapView.Location mapCenter = await _mapView.centerLocation;
    print("LAT LNG ${mapCenter.latitude} ${mapCenter.longitude}");
    places.PlacesSearchResponse placeResponse =
        await _places.searchNearbyWithRadius(
            places.Location(mapCenter.latitude, mapCenter.longitude), 1000,
            type: "restaurant");
    if (placeResponse.hasNoResults) {
      print("No results");
      return;
    } else {
      print("RES ${placeResponse.errorMessage}");
      List<places.PlacesSearchResult> results = placeResponse.results;
      _updateMarkers(results);
    }
  }

  void _showMap() async {
    final location = geoloc.Location();
    try {
      var currentLocation = await location.getLocation();
      print('${currentLocation['latitude']} ${currentLocation['longitude']}');
      _mapView.show(
          mapView.MapOptions(
              mapViewType: mapView.MapViewType.normal,
              showUserLocation: true,
              initialCameraPosition: mapView.CameraPosition(
                  mapView.Location(currentLocation['latitude'],
                      currentLocation['longitude']),
                  14.0),
              title: "Recently Visited"),
          toolbarActions: [mapView.ToolbarAction("Close", 1)]);
      _mapView.onMapReady.listen((_) => _findRestaurantsAround());
      //_getStaticMap(currentLocation['latitude'], currentLocation['longitude']);
    } catch (err) {
      print(err);
      _currentLocation = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _showMap();
    _mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        _mapView.dismiss();
      }
    });
  }

  // call when deconstruct to avoid a memory leak
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          onPressed: _showMap,
          child: Text('Show map'),
        )
      ],
    );
  }
}
