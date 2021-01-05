import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';

import 'dart:async';
import 'package:loading/loading.dart';

void main() => runApp(FilmIMDB());

class FilmIMDB extends StatefulWidget {
  @override
  FilmIMDBState createState() => FilmIMDBState();
}

class FilmIMDBState extends State<FilmIMDB> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
      appBar: AppBar(
        title: Text("IMDB Films"),
      ),
      body: _functionLoading(),
    ));
  }
}

Widget _functionLoading() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Loading(
            indicator: BallGridPulseIndicator(),
            size: 50.0,
            color: Colors.black45,
          ),
          Text("Carregando dados...")
        ],
      ),
    ),
  );
}
