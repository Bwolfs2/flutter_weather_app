import 'package:dio/dio.dart';

import 'package:flutter_weather_app/models/weather.dart';

class WeatherApiClient {
  static const baseUrl = 'https://www.metaweather.com';
  final Dio dio;

  WeatherApiClient(this.dio);

  Future<int> getLocationId(String city) async {
    final locationUrl = '$baseUrl/api/location/search/?query=$city';

    Response response = await dio.get(locationUrl);

    if (response.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }

    final locationJson = response.data;
    return (locationJson.first)['woeid'];
  }

  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = '$baseUrl/api/location/$locationId';
    final weatherResponse = await this.dio.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }

    final weatherJson = weatherResponse.data;
    return Weather.fromJson(weatherJson);
  }
}
