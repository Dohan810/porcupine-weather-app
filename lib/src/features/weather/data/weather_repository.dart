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
      // return ForecastData.fromJson(data);
      return _filterDailyForecast(data);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  ForecastData _filterDailyForecast(Map<String, dynamic> data) {
    final List<dynamic> list = data['list'];
    final Map<String, WeatherList> dailyForecastMap = {};

    for (final item in list) {
      final weatherData = WeatherList.fromJson(item as Map<String, dynamic>);
      final date = DateTime.parse(weatherData.dtTxt);
      final day = "${date.year}-${date.month}-${date.day}";

      // Prioritize forecasts around noon or any specific time
      if (!dailyForecastMap.containsKey(day) || (date.hour == 12)) {
        dailyForecastMap[day] = weatherData;
      }
    }

    final filteredList = dailyForecastMap.values.toList();
    return ForecastData(
      cod: data['cod'],
      message: data['message'],
      cnt: filteredList.length,
      list: filteredList,
      city: City.fromJson(data['city']),
    );
  }
}
