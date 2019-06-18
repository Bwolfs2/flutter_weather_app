import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/blocs/theme_bloc.dart';
import 'package:flutter_weather_app/blocs/weather_bloc.dart';
import 'package:flutter_weather_app/models/image_condition_helper.dart';
import 'package:flutter_weather_app/models/weather.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  var bloc = BlocProvider.getBloc<WeatherBloc>();
  var blocTheme = BlocProvider.getBloc<ThemeBloc>();

  final List<PopupMenuItem<int>> dropList = new List<PopupMenuItem<int>>();

  PopupMenuItem<int> popupMenuItem(String text, int value) {
    return PopupMenuItem<int>(
      child: Row(
        children: <Widget>[
          Container(
            child: Text("$text"),
            width: 200,
          )
        ],
      ),
      value: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: StreamBuilder<Color>(
              stream: blocTheme.appBarColor,
              builder: (context, AsyncSnapshot snapshot) {
                return AppBar(
                  backgroundColor: snapshot.data,
                  title: Center(
                    child: Text("Flutter Weather"),
                  ),
                  actions: <Widget>[
                    PopupMenuButton<int>(
                      offset: Offset(100, 100),
                      icon: Icon(Icons.settings),
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<int>>[
                          popupMenuItem("Rio de Janeiro", 0),
                          popupMenuItem("São Paulo", 1),
                          popupMenuItem("Brasília", 2),
                          popupMenuItem("Salvador", 3),
                          popupMenuItem("Calgary", 4),
                        ];
                      },
                      onSelected: (val) {
                        switch (val) {
                          case 0:
                            {
                              bloc.changeCity.add("Rio de Janeiro");
                              break;
                            }
                          case 1:
                            {
                              bloc.changeCity.add("São Paulo");
                              break;
                            }
                          case 2:
                            {
                              bloc.changeCity.add("Brasília");
                              break;
                            }
                          case 3:
                            {
                              bloc.changeCity.add("Salvador");
                              break;
                            }
                          case 4:
                            {
                              bloc.changeCity.add("Calgary");
                              break;
                            }
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                    )
                  ],
                );
              }),
        ),
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
              blocTheme.setWeather(snapshot.data);
              return StreamBuilder<List<Color>>(
                stream: blocTheme.gradientColorStream,
                initialData: <Color>[Colors.white, Colors.white, Colors.white],
                builder: (context, snapshotTheme) {
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
          StreamBuilder<BlocState<Weather>>(
            stream: bloc.weatherStateFlux,
            builder: (_, snap) {
              if (snap.data == null || snap.data.isLoaded()) {
                return Container();
              }

              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff99000000),
                  ),
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      padding: EdgeInsets.all(30),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: snap.data.isSuccess()
                                ? Icon(
                                    Icons.done,
                                    color: Colors.greenAccent,
                                    size: 80,
                                  )
                                : snap.data.hasError()
                                    ? Icon(
                                        Icons.close,
                                        color: Colors.redAccent,
                                        size: 80,
                                      )
                                    : CircularProgressIndicator(
                                        strokeWidth: 8,
                                      ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          snap.data.isSuccess()
                              ? Text(
                                  "Success",
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 25,
                                  ),
                                )
                              : snap.data.hasError()
                                  ? Text(
                                      "Error",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 25,
                                      ),
                                    )
                                  : Text(
                                      "Loading",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 25,
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
