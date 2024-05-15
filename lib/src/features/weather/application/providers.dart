import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/models/forecast_data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/models/weather_data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
  );

  String city = 'London';
  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;

  WeatherState currentWeatherState = WeatherState.initial;
  WeatherState forecastWeatherState = WeatherState.initial;

  String? errorMessage;

  Future<void> getWeatherData() async {
    try {
      currentWeatherState = WeatherState.loading;
      forecastWeatherState = WeatherState.loading;
      notifyListeners();

      final weather = await repository.getWeather(city: city);
      currentWeatherProvider = weather;

      await getForecastData();

      currentWeatherState = WeatherState.loaded;
      forecastWeatherState = WeatherState.loaded;
    } catch (e) {
      currentWeatherState = WeatherState.error;
      forecastWeatherState = WeatherState.error;
      errorMessage = "Unable to find location";
    } finally {
      notifyListeners();
    }
  }

  Future<void> getForecastData() async {
    try {
      final forecast = await repository.getForecast(city: city);
      hourlyWeatherProvider = forecast;
    } catch (e) {
      forecastWeatherState = WeatherState.error;
      errorMessage = "Unable to find location";
    }
  }
}
