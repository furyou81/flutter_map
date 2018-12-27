import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import './pages/home_page.dart';
import './keys.dart';

void main() {
  MapView.setApiKey(API_KEY);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
