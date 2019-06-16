import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc extends BlocBase {
  var _gradientController = BehaviorSubject<List<Color>>.seeded(<Color>[Colors.red, Colors.white, Colors.white]);
  var _appBarColorController = BehaviorSubject<Color>.seeded(Colors.blueAccent);

  Observable<List<Color>> get gradientColorStream => _gradientController.stream;

  Observable<Color> get appBarColor => _appBarColorController.stream;

  setWeather(Weather weather) {
    fillTheme(weather.condition);
  }

  fillTheme(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
      _appBarColorController.add(Color(0xffFBC02D));
        _gradientController.add(<Color>[
          Color(0xffE2AD29),
          Color(0xffFBC02D),
          Color(0xffFAEF73),
        ]);
        break;
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
      case WeatherCondition.hail:
      _appBarColorController.add(Color(0xff0388D1));
        _gradientController.add(<Color>[
          Color(0xff0872A8),
          Color(0xff0388D1),
          Color(0xff4DC2F6),
        ]);
        break;

      case WeatherCondition.thunderstorm:
        _appBarColorController.add(Color(0xff512EA8));
        _gradientController.add(<Color>[
          Color(0xff43258B),
          Color(0xff512EA8),
          Color(0xff9272CA),
        ]);
        break;
      case WeatherCondition.showers:
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      _appBarColorController.add(Color(0xff303F9F));
        _gradientController.add(<Color>[
          Color(0xff2A378D),
          Color(0xff303F9F),
          Color(0xff7681C6),
        ]);
        break;
      case WeatherCondition.heavyCloud:
        _appBarColorController.add(Color(0xff512EA8));
        _gradientController.add(<Color>[
          Color(0xff43258B),
          Color(0xff512EA8),
          Color(0xff9272CA),
        ]);
        break;
      case WeatherCondition.unknown:
        _appBarColorController.add(Colors.white);
        _gradientController.add(<Color>[
          Colors.white,
          Colors.white,
          Colors.white,
        ]);
    }
  }
}
