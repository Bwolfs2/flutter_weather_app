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
              builder: (context, snapshot) {
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
                              bloc.atualizar("Rio de Janeiro");
                              break;
                            }
                          case 1:
                            {
                              bloc.atualizar("São Paulo");
                              break;
                            }
                          case 2:
                            {
                              bloc.atualizar("Brasília");
                              break;
                            }
                          case 3:
                            {
                              bloc.atualizar("Salvador");
                              break;
                            }
                          case 4:
                            {
                              bloc.atualizar("Calgary");
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
      body: StreamBuilder<Weather>(
          stream: bloc.weatherStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

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
                            colors: snapshotTheme.data)),
                    child: Center(
                      child: Container(
                          height: 350,
                          padding: EdgeInsets.symmetric(horizontal: 70),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "${snapshot.data.location}",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "comic_sandchez"),
                              ),
                              Text("Updated: 11:16 PM",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ImageConditionHelper.mapConditionToImage(
                                      snapshot.data.condition),
                                  Text(
                                    "${snapshot.data.temp.toString().split(".")[0]}°",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "max: ${snapshot.data.maxTemp.toString().split(".")[0]}°",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      Text(
                                        "min: ${snapshot.data.minTemp.toString().split(".")[0]}°",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "${snapshot.data.formattedCondition}",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    fontFamily: "comic_sandchez"),
                              ),
                            ],
                          )),
                    ),
                  );
                });
          }),
    );
  }
}
