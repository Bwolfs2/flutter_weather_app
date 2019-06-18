import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/pages/home_page.dart';

import 'blocs/theme_bloc.dart';
import 'blocs/weather_bloc.dart';
import 'blocs/weather_interceptor.dart';
import 'infraestructure/weather_api_client.dart';
import 'repositories/weather_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
       blocs: [
         Bloc((i)=>WeatherBloc(i.getDependency<WeatherInterceptor>())),
         Bloc((i)=>ThemeBloc(i.getDependency<WeatherInterceptor>())),
       ],
       dependencies: [
         Dependency((i) => Dio()),
         Dependency((i) => WeatherApiClient(i.getDependency<Dio>())),
         Dependency((i) => WeatherRepository(i.getDependency<WeatherApiClient>())),
         //Interceptor
         Dependency((i)=>WeatherInterceptor(i.getDependency<WeatherRepository>()), singleton: true),
       ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
