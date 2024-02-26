import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../constants/config.dart';
import '../../databases/db_helper.dart';
import '../../models/weather_model.dart';
import '../loginScreens/login_page.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WeatherState();
  }
}

class WeatherState extends State<WeatherPage> {
  List<current> weather = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _refreshWeather() async {
    setState(() {
      weather.clear();
    });
    await getweather();
  }

  int hour = DateTime.now().hour;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: FutureBuilder<List<forecast>>(
            future: getweather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                // Fetch data from local database
                return FutureBuilder<Map<String, dynamic>>(
                  future: DatabaseHelper().getLastWeather(),
                  builder: (context, dbSnapshot) {
                    if (dbSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (dbSnapshot.hasError) {
                      return Center(
                        child: Text('Error retrieving data from database: ${dbSnapshot.error.toString()}'),
                      );
                    } else {
                      final lastWeatherData = dbSnapshot.data!;
                      if (lastWeatherData.isEmpty) {
                        return const Center(
                          child: Text('No weather data available'),
                        );
                      } else {
                        return buildWeatherUI(lastWeatherData);
                      }
                    }
                  },
                );
              } else {
                //print(snapshot.data);
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: getcolor()),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            "Today's Weather",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: 120,
                              width: 120,
                              child: Image.asset(
                                getWeatherIcon(weather[0].id),
                                fit: BoxFit.fill,
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${(weather[0].temp - 273.15).toStringAsFixed(1)}°",
                                style: GoogleFonts.poppins(
                                    fontSize: 40, color: Colors.white),
                              ),
                              Text(
                                weather[0].weather,
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Humidity',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${(weather[0].humidity).toStringAsFixed(1)}%",
                                style: GoogleFonts.poppins(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Pressure',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${(weather[0].pressure)}",
                                style: GoogleFonts.poppins(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Text(
                            'Forecast :',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          )),
                      Expanded(
                        child: GridView(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.5,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5.0),
                            children: snapshot.data!.map((document) {
                              return Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEEE').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            document.dt * 1000)),
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Image.asset(
                                            getWeatherIcon(document.desc)),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Max:  ${(document.max - 273.15).toStringAsFixed(1)}°',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Max:  ${(document.min - 273.15).toStringAsFixed(1)}°',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList()),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    ));
  }

  Widget buildWeatherUI(Map<String, dynamic> weatherData) {
    double temperature = weatherData['temperature'];
    int humidity = weatherData['humidity'];
    int pressure = weatherData['pressure'];

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to transparent
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                "Today's Weather",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature: ${(temperature - 273.15).toStringAsFixed(1)}°C',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Humidity: $humidity%',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Pressure: $pressure',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Add your UI to display other weather data
          ],
        ),
      ),
    );
  }

  List<Color> getcolor() {
    if (hour >= 6 && hour <= 11) {
      return [
        const Color(0xFF83eaf1),
        const Color(0xFF3eadcf)
      ]; //const Color(0xFF83eaf1), const Color(0xFF3eadcf)
    } else if (hour > 11 && hour <= 16) {
      return [const Color(0xFFFFDF00), const Color(0xFFF6D108)];
    } else if (hour > 16 && hour < 19) {
      return [
        Color(0xFF4e54c8),
        const Color(0xFF9795ef),
      ];
    } else {
      return [const Color(0xFF001D37), const Color(0xFF01162E)];
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return 'assets/ic_storm_weather.png';
    } else if (condition < 400) {
      return 'assets/ic_rainy_weather.png';
    } else if (condition < 600) {
      return 'assets/ic_rainy_weather.png';
    } else if (condition < 700) {
      return 'assets/ic_snow_weather.png';
    } else if (condition < 800) {
      return 'assets/ic_mostly_cloudy.png';
    } else if (condition == 800) {
      return 'assets/ic_clear_day.png';
    } else if (condition <= 804) {
      return 'assets/ic_cloudy_weather.png';
    } else {
      return 'assets/ic_unknown.png';
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //Getting weather details
  Future<List<forecast>> getweather() async {
    Dio dio = Dio();
    Position p = await _determinePosition();
    Response r = await dio.get(
        "https://api.openweathermap.org/data/2.5/onecall?lat=${p.latitude}&lon=${p.longitude}&exclude=hourly,minutely&appid=$apiKey");
    //print(r.body);
    print(r.statusCode);
    if (r.statusCode == 200) {
      Map<String, dynamic> x = r.data;
      //print(x['current']);
      weather.add(current(
          x['current']['temp'],
          x['current']['weather'][0]['description'],
          x['current']['weather'][0]['main'],
          x['current']['humidity'],
          x['current']['weather'][0]['id'],
          x['current']['pressure']));
      var y = x['daily'];

      List<forecast> z = [];
      for (var i = 1; i < 5; i++) {
        //print(y[i]['weather'][0]['id']);
        z.add(forecast(
            y[i]['dt'],
            y[i]['humidity'],
            y[i]['temp']['max'],
            y[i]['temp']['min'],
            y[i]['weather'][0]['main'],
            y[i]['weather'][0]['id']));
      }
      await DatabaseHelper().saveLastWeather(
          weather[0].temp,
          weather[0].humidity,
          weather[0].pressure,
          weather[0].weather,
          weather[0].id);
      print(z);
      return z;
    } else {
      return [];
    }
  }
}
