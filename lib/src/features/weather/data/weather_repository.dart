import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/models/forecast_data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';

class HttpWeatherRepository {
  final OpenWeatherMapAPI api;
  final http.Client client;

  HttpWeatherRepository({required this.api, required this.client});

  Future<WeatherData?> getWeather({required String city}) async {
    final Uri url = api.weather(city);

    final http.Response response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return WeatherData.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<ForecastData?> getForecast({required String city}) async {
    final Uri url = api.forecast(city);
    final http.Response response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ForecastData.fromJson(data);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
