import 'package:flutter/material.dart';
import 'package:keu/screen/main_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Keuangan',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainScreen(),
      // routes: routes,
    );
  }
}
