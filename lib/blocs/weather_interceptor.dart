import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'BlocStates.dart';

class WeatherInterceptor extends BlocBase
{ 
  final _weatherController =  new BehaviorSubject<Weather>(sync: true);

  final _statesController = BehaviorSubject<BlocStates<Weather>>(sync: true);

  Observable<Weather> get weatherFlux => _weatherController.stream;
  Sink<Weather> get weatherSink => _weatherController.sink;

  Observable<BlocStates<Weather>> get weatherStateFlux => _statesController.stream;
  Sink<BlocStates<Weather>> get weatherStateSink => _statesController.sink;

  @override
  void dispose() {    
    super.dispose();
    _weatherController.close();
    _statesController.close();
  }
}