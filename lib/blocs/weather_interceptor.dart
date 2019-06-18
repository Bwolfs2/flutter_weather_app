import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'BlocStates.dart';

class WeatherInterceptor extends BlocBase
{
  WeatherRepository _api;
  WeatherInterceptor(this._api);

  final _weatherController = new BehaviorSubject<String>.seeded("Rio de Janeiro");

  Observable<Weather> get weatherFlux => weatherStateFlux.where((mp) => mp.isSuccess()).map((mp) => mp.obj);

  Observable<BlocStates<Weather>> get weatherStateFlux => _weatherController.stream.concatMap((item) => _getApi(item));

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
    _weatherController.close();
    super.dispose();
  }
}