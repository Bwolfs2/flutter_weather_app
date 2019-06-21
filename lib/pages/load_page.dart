import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/blocs/BlocStates.dart';
import 'package:flutter_weather_app/blocs/weather_bloc.dart';
import 'package:flutter_weather_app/models/weather.dart';

class LoadPage extends StatelessWidget {

  final bloc = BlocProvider.getBloc<WeatherBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlocStates<Weather>>(
      stream: bloc.weatherStateFlux,
      builder: (_, snap) {
        if (!snap.hasData || snap.data.isLoaded()) {
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
                child: snap.data.isSuccess()
                    ? SuccessView()
                    : snap.data.hasError() ? ErrorView() : LoadingView(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: 80,
            height: 80,
            child: Icon(
              Icons.done,
              color: Colors.greenAccent,
              size: 80,
            )),
        SizedBox(
          height: 20,
        ),
        Text(
          "Success",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 25,
          ),
        )
      ],
    );
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 8,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Loading",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
          ),
        )
      ],
    );
  }
}

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: 80,
            height: 80,
            child: Icon(
              Icons.close,
              color: Colors.redAccent,
              size: 80,
            )),
        SizedBox(
          height: 30,
        ),
        Text(
          "Error",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 25,
          ),
        )
      ],
    );
  }
}
