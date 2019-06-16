import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter_weather_app/infraestructure/weather_api_client.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/repositories/weather_repository.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends BlocBase{

  var _api = WeatherRepository(weatherApiClient:  WeatherApiClient(dio: Dio()));


  var _controller = BehaviorSubject<Weather>();

  Observable<Weather> get weatherStream => _controller.stream;

  void atualizar(String string){
    _api.getWeather(string).then((data) async =>_controller.add(data));
  }

  WeatherBloc(){
    //São Paulo
    atualizar("Rio de Janeiro");
    //_api.getWeather("Rio de Janeiro").then((data) async =>_controller.add(data));
  }
}