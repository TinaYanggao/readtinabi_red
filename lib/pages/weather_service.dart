import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather_model.dart';

class WeatherService {
  final String apiKey = '6a641d65b46bd608b6d3b29bde64c9fc';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}