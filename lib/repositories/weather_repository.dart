import 'package:flutter_weather_app/infraestructure/weather_api_client.dart';
import 'package:flutter_weather_app/models/weather.dart';

class WeatherRepository {
  final WeatherApiClient _weatherApiClient;

  WeatherRepository(this._weatherApiClient);

  Future<Weather> getWeather(String city) async {
    final int locationId = await _weatherApiClient.getLocationId(city);
    return _weatherApiClient.fetchWeather(locationId);
  }
}