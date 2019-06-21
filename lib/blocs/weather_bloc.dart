import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/blocs/weather_bloc_state.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends BlocBase {
  WeatherRepository _api;
  WeatherBloc(this._api)
  {
    weatherFlux = weatherStateFlux.where((mp) => mp.isSuccess()).map((mp) => mp.obj);
    weatherStateFlux = _weatherController.stream.concatMap((item) => _getApi(item));
  }

  final _weatherController = new BehaviorSubject<String>.seeded("Rio de Janeiro");
  Sink<String> get weatherSink =>_weatherController.sink;

  Observable<Weather> weatherFlux;

  Observable<BlocState<Weather>> weatherStateFlux;

  Stream<BlocState<Weather>> _getApi(String string) async* {

    yield BlocState.loading();

    try {
      var data = await _api.getWeather(string);

      yield BlocState.success(data);

      await Future.delayed(Duration(milliseconds: 500));

      yield BlocState.loaded();
    } catch (e) {
      yield BlocState.error(e.toString());
    }
  }

  @override
  void dispose() {
 _weatherController.close();
    super.dispose();
  }
}