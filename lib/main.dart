import 'file:///D:/projects/fliccs/lib/pages/start_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: SearchPage(),
      theme: ThemeData(
          textTheme: TextTheme(
              subtitle1: TextStyle(
                  color: Color(0xFFf1faee), fontFamily: 'Montserrat')),
          cursorColor: Color(0xFFf1faee),
          fontFamily: 'Montserrat',
          primaryColor: Color(0xFFf1faee),
          accentColor: Color(0xFFf1faee)),
    );
  }
}
