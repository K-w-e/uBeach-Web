import 'package:flutter/material.dart';
import 'package:ubeachweb/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'uBeach - Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          highlightColor: Colors.cyan[400]),
      home: LoginPage(),
    );
  }
}
