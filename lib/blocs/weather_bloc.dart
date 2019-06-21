import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/blocs/weather_interceptor.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'BlocStates.dart';

class WeatherBloc extends BlocBase {
  WeatherRepository _api;

  WeatherInterceptor _interceptor;

  List<StreamSubscription> _subscriptions;

  WeatherBloc(this._interceptor, this._api) {

  weatherStateFlux = _weatherController.stream.switchMap(_getApi);

   weatherFlux =
        weatherStateFlux.where((mp) => mp.isSuccess()).map((mp) => mp.obj);

    _subscriptions = <StreamSubscription>[
      weatherFlux.listen(_interceptor.weatherSink.add),
      weatherStateFlux.listen(_interceptor.weatherStateSink.add)
    ];

 
  }

  Observable<Weather> weatherFlux;

  Observable<BlocStates<Weather>> weatherStateFlux;

  final _weatherController =
      new BehaviorSubject<String>.seeded("Rio de Janeiro", sync: true);

  final _statesController = BehaviorSubject<BlocStates<Weather>>(sync: true);

  Sink<String> get changeCity => _weatherController.sink;

  Stream<BlocStates<Weather>> _getApi(String string) async* {
    yield BlocStates.loading();

    try {
      var data = await _api.getWeather(string);

      yield BlocStates.success(data);

      await Future.delayed(Duration(milliseconds: 500));

      yield BlocStates.loaded();
    } catch (e) {
      yield BlocStates.error(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _weatherController.close();
    _weatherController.close();
    _statesController.close();
    _subscriptions.forEach((s) => s.cancel());
  }
}
