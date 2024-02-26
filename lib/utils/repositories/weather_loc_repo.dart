import 'package:dio/dio.dart';
import 'package:tikeri/constants/config.dart';
import 'package:tikeri/models/weather_model.dart';

class WeatherRepositoryLoc {
  Future<Weather> fetchWeather(String location) async {
    try {
      Dio dio = Dio();
      Response response = await dio.get(
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric',
      );
      if (response.statusCode == 200) {
        final jsonData = response.data;
        final weather = Weather.fromJson(jsonData);
        return weather;
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather data');
    }
  }
}
