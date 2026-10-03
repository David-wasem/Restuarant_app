import 'package:api_app/exceptions/exception_handler.dart';
import 'package:api_app/models/current_model.dart';
import 'package:api_app/models/astronomy_model.dart';
import 'package:api_app/services/api_dio.dart';
import 'package:api_app/services/api_keys.dart';
import 'package:api_app/services/weather_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  final String city;
  const WeatherPage({super.key, required this.city});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final WeatherApi api;
  double? tempCelcuis;
  String? sunRise;

  @override
  void initState() {
    super.initState();
    api = WeatherApi(
      api: ApiDio(
        baseURL: ApiKeys.weatherBASEURL,
        dio: Dio(),
      ),
    );
    getCurrentWeather(widget.city);
    getAstronomyWeather(widget.city);
  }

  Future<dynamic> getCurrentWeather(String location) async {
    try {
      final res = await api.getCurrent(location: location);
      CurrentModel current = CurrentModel.fromJson(res as Map<String, dynamic>);
      if (!mounted) return;
      setState(() {
        tempCelcuis = current.temp_c;
      });
    } on DioException catch (e) {
      final message = ExceptionHandler.handle(
        e,
        unauthorizedMessage: 'Invalid weather API key',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message =====  ${e.response?.statusCode}")),
      );
      print(message);
    }
  }

  Future<dynamic> getAstronomyWeather(String location) async {
    try {
      final res = await api.getAstronomy(location: location);
      AstronomyModel astro = AstronomyModel.fromJson(
        res as Map<String, dynamic>,
      );
      if (!mounted) return;
      setState(() {
        sunRise = astro.sunrise;
      });
    } on DioException catch (e) {
      final message = ExceptionHandler.handle(
        e,
        unauthorizedMessage: 'Invalid weather API key',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message =====  ${e.response?.statusCode}")),
      );
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [Color(0xff62B8F6), Color(0xff2C79C1)],
                  begin: AlignmentGeometry.topLeft,
                  end: AlignmentGeometry.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Current",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/current_weather.png",
                        width: 180,
                      ),
                      (tempCelcuis == null)
                          ? Text(
                              "Server Problem",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  "$tempCelcuis",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.city,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [Color(0xff62B8F6), Color(0xff2C79C1)],
                  begin: AlignmentGeometry.topLeft,
                  end: AlignmentGeometry.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "SunRise Time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/astronomy_weather.png",
                        width: 180,
                      ),
                      (sunRise == null)
                          ? Text(
                              "Server Problem",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  "$sunRise",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.city,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
              child: Text(
                "Back To Home",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
