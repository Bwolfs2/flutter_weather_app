import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/blocs/theme_bloc.dart';
import 'package:flutter_weather_app/blocs/weather_bloc.dart';

class HomeAppBar extends StatelessWidget {

  final bloc = BlocProvider.getBloc<WeatherBloc>();
  final blocTheme = BlocProvider.getBloc<ThemeBloc>();

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
    return Container(
      child: StreamBuilder(
        stream: blocTheme.obs,
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return AppBar();
          }
          return AppBar(
            backgroundColor: snapshot.data[1] as Color,
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
        },
      ),
    );
  }
}
