import 'package:flutter/material.dart';
import 'package:flutter_weather_app/pages/weather_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WeatherScreen();
  }
}
