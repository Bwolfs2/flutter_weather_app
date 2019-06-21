import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/blocs/weather_interceptor.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:rxdart/rxdart.dart';

import 'BlocStates.dart';

class WeatherBloc extends BlocBase {
  WeatherInterceptor _interceptor;
  List<StreamSubscription> _subscriptions;

  WeatherBloc(this._interceptor) {
    _subscriptions = <StreamSubscription>[
      _interceptor.weatherFlux.listen(_weatherController.add),
      _interceptor.weatherStateFlux.listen(_statesController.add)
    ];
 
  }

  var _weatherController = BehaviorSubject<Weather>(sync:true);
  var _statesController = BehaviorSubject<BlocStates<Weather>>(sync:true);

  Observable<Weather> get weatherFlux => _weatherController.stream;

  Observable<BlocStates<Weather>> get weatherStateFlux =>
      _statesController.stream;

  Sink<String> get changeCity => _interceptor.changeCity;


  @override
  void dispose() { 
    super.dispose();
    _weatherController.close();
    _statesController.close();
    _subscriptions.forEach((s)=>s.cancel());
  }
}
