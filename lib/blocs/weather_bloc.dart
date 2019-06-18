import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends BlocBase {
  WeatherRepository _api;
  WeatherBloc(this._api);

  final _weatherController = new BehaviorSubject<String>.seeded("Rio de Janeiro");
  Sink<String> get weatherSink =>_weatherController.sink;

  Observable<Weather> get weatherFlux => weatherStateFlux.where((mp) => mp.isSuccess()).map((mp) => mp.obj);

  Observable<BlocState<Weather>> get weatherStateFlux =>
      _weatherController.stream.concatMap((item) => _getApi(item));


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

class BlocState<T> {
  T obj;
  Stats stats;
  String error;

  BlocState.success(this.obj) {
    this.stats = Stats.finishLoad;
  }

  BlocState.error(String error) {
    this.stats = Stats.error;
    this.error = error;
  }

  BlocState.loaded() {
    this.stats = Stats.loaded;
  }

  BlocState.loading() {
    this.stats = Stats.loading;
  }

  bool isSuccess() {
    return this.stats == Stats.finishLoad;
  }

  bool hasError() {
    return this.stats == Stats.finishLoad;
  }

  bool isLoaded() {
    return this.stats == Stats.loaded;
  }
}

enum Stats { loading, finishLoad, error, loaded }
