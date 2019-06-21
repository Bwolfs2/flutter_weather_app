import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/blocs/weather_interceptor.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc extends BlocBase {
  WeatherInterceptor _interceptor;
  List<StreamSubscription> _subscriptions;

  ThemeBloc(this._interceptor) {
    _subscriptions = <StreamSubscription>[
      _interceptor.weatherFlux.listen(_gradientController.add),
    ];

    gradientColorStream =
        _gradientController.map((item) => _getGradient(item.condition));

    appBarColor = _gradientController.map((item) => _getColor(item.condition));

    obs = Observable.zip2<List<Color>, Color, List>(
        gradientColorStream, appBarColor, (a, b) {
      return [a, b];
    }).asBroadcastStream();

    obs.listen((e) {
      print(e[0]);
    });
  }

  Observable obs;

  var _gradientController = BehaviorSubject<Weather>(sync: true);

  Observable<List<Color>> gradientColorStream;

  Observable<Color> appBarColor;

  @override
  dispose() {
    super.dispose();
    _gradientController.close();
    _subscriptions.forEach((e) => e.cancel());
  }

  _getGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        return <Color>[
          Color(0xffE2AD29),
          Color(0xffFBC02D),
          Color(0xffFAEF73),
        ];
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
      case WeatherCondition.hail:
        return <Color>[
          Color(0xff0872A8),
          Color(0xff0388D1),
          Color(0xff4DC2F6),
        ];
      case WeatherCondition.thunderstorm:
        return <Color>[
          Color(0xff43258B),
          Color(0xff512EA8),
          Color(0xff9272CA),
        ];
      case WeatherCondition.showers:
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
        return <Color>[
          Color(0xff2A778D),
          Color(0xff197F9F),
          Color(0xff4DC2F6),
        ];
      case WeatherCondition.heavyCloud:
        return <Color>[
          Color(0xff71E566),
          Color(0xff88E57F),
          Color(0xffCEE5CC),
        ];
      case WeatherCondition.unknown:
        return <Color>[
          Colors.white,
          Colors.white,
          Colors.white,
        ];
    }

    return <Color>[
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  _getColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        return Color(0xffFBC02D);
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
      case WeatherCondition.hail:
        return Color(0xff0388D1);

      case WeatherCondition.thunderstorm:
        return Color(0xff512EA8);

      case WeatherCondition.showers:
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
        return Color(0xff197F9F);

      case WeatherCondition.heavyCloud:
        return Color(0xff512EA8);

      case WeatherCondition.unknown:
        return Colors.white;
    }
  }
}
