import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:http/http.dart' as http;
// import 'dart:async';
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
          drawer: _drawerSide(),
          appBar: AppBar(
            title: Text("IMDB Films"),
          ),
          body: Container(
            child: FutureBuilder(
              future: httpMainRequest(
                  "/title/get-most-popular-movies", {"currentCountry": "BR"}),
              builder: (context, snapshot) {
                List newSnapshot = json.decode(snapshot.data);
                print(newSnapshot);
                if (snapshot.hasError) {
                  return Text("Ocorreu algum erro, reinicie o aplicativo");
                } else if (snapshot.hasData) {
                  return GridView.builder(
                      itemCount: 20,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.5),
                      itemBuilder: (_, index) {
                        return Container(
                            child: FutureBuilder(
                                future: _fakeRequest(newSnapshot[index]),
                                builder: (ctx, snapshot) {
                                  if (snapshot.hasError) {
                                    return _functionLoading();
                                  } else if (snapshot.hasData) {
                                    return Container(
                                   
                                      child: Column(
                                        children: [
                                          Image.network(
                                              snapshot.data['image']['url']),
                                          Text(snapshot.data['title'])
                                        ],
                                      ),
                                    );
                                  } else {
                                    return _functionLoading();
                                  }
                                }));
                      });
                } else {
                  return _functionLoading();
                }
              },
            ),
          ),
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
        Text("Carregando dados..."),
      ],
    ),
  ));
}

Widget _drawerSide() {
  return SafeArea(
    child: Drawer(
      child: Column(
        children: [
          Text(
            "IMDB FILMS",
            style: TextStyle(fontSize: 20.0),
          )
        ],
      ),
    ),
  );
}

Future<String> httpMainRequest(String typeRequestUrl, var parameters) async {
  var url = 'imdb8.p.rapidapi.com';
  print("API SEARCH...");
  Map<String, String> headersRequest = {
    'x-rapidapi-host': 'imdb8.p.rapidapi.com',
    'x-rapidapi-key': '278fc18414msh501186d390b9990p1a4b59jsnd5a443594c01',
    'useQueryString': 'true',
  };

  var queryParameters = parameters;
  var uri = Uri.https(url, "$typeRequestUrl", queryParameters);
  var response = await http.get(
    uri,
    headers: headersRequest,
  );
  if (response.statusCode != 200) {
    throw Exception(
        "Request to $url failed with status ${response.statusCode}: ${response.body}");
  }

  return response.body;
}

dynamic _fakeRequest(String titleFilm) async {
  var url = 'imdb8.p.rapidapi.com';
  print("API IMAGE...$titleFilm");
  Map<String, String> headersRequest = {
    'x-rapidapi-host': 'imdb8.p.rapidapi.com',
    'x-rapidapi-key': '278fc18414msh501186d390b9990p1a4b59jsnd5a443594c01',
    'useQueryString': 'true',
  };

  String newTconst = titleFilm.replaceAll("/title/", "");
  print(newTconst);
  var queryParameters = {"tconst": newTconst};
  var uri = Uri.https(url, "/title/get-details", queryParameters);
  var response = await http.get(
    uri,
    headers: headersRequest,
  );
  if (response.statusCode != 200) {
    throw Exception(
        "Request to $url failed with status ${response.statusCode}: ${response.body}");
  }
  var jsonReceived = json.decode(response.body);

  return jsonReceived;
}
