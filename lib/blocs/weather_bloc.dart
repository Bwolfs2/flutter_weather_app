import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/blocs/weather_interceptor.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:rxdart/rxdart.dart';

import 'BlocStates.dart';

class WeatherBloc extends BlocBase {

  WeatherInterceptor _interceptor;

  WeatherBloc(this._interceptor);

  Observable<Weather> get weatherFlux => _interceptor.weatherFlux;

  Observable<BlocStates<Weather>> get weatherStateFlux => _interceptor.weatherStateFlux;

  Sink<String> get changeCity => _interceptor.changeCity;

}
