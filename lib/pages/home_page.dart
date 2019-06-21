import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/blocs/theme_bloc.dart';
import 'package:flutter_weather_app/blocs/weather_bloc.dart';
import 'package:flutter_weather_app/models/image_condition_helper.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'home_app_bar.dart';
import 'load_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bloc = BlocProvider.getBloc<WeatherBloc>();
  var blocTheme = BlocProvider.getBloc<ThemeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: HomeAppBar(),
        preferredSize: Size.fromHeight(60),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<Weather>(
            stream: bloc.weatherFlux,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var stateWeather = snapshot.data;
              return StreamBuilder<List<Color>>(
                stream: blocTheme.gradientColorStream,
                initialData: <Color>[Colors.white, Colors.white, Colors.white],
                builder: (context, snapshotTheme) {

                  if(!snapshotTheme.hasData){
                    return Container();
                  }

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: snapshotTheme.data,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 350,
                        padding: EdgeInsets.symmetric(horizontal: 70),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "${stateWeather.location}",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "comic_sandchez",
                              ),
                            ),
                            Text(
                              "Updated: 11:16 PM",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ImageConditionHelper.mapConditionToImage(
                                    stateWeather.condition),
                                Text(
                                  "${stateWeather.temp.toString().split(".")[0]}°",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "max: ${stateWeather.maxTemp.toString().split(".")[0]}°",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                    Text(
                                      "min: ${stateWeather.minTemp.toString().split(".")[0]}°",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "${stateWeather.formattedCondition}",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontFamily: "comic_sandchez",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
         LoadPage()
        ],
      ),
    );
  }
}
