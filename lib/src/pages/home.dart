import 'package:flutter/material.dart';
import 'package:flutterclock/src/constants/colors.dart';
import 'package:flutterclock/src/widgets/clock.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Center(
        child: Clock(
          smooth: true,
          size: Size.fromRadius(150),
        ),
      ),
    );
  }
}
