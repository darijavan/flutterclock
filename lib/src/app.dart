import 'package:flutter/material.dart';
import 'package:flutterclock/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter clock',
      initialRoute: '/',
      routes: routes,
    );
  }
}
